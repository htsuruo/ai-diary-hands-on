import { ActionContext, UserFacingError, z } from "genkit";

import { ai } from "../genkit";
import { diaryRetrieverFlow } from "./diary-retriever";

const prompt = ai.prompt("memory-assistant-rag/memory-assistant");

const inputSchema = z.object({
  query: z.string().describe("ユーザーの質問"),
});

const diarySourceSchema = z.object({
  date: z.string().describe("日記の作成日（ISO 8601形式）"),
  documentId: z.string().describe("ドキュメントID"),
  content: z.string().describe("日記の内容"),
});

type DiarySource = z.infer<typeof diarySourceSchema>;

const outputSchema = z.object({
  answer: z.string().describe("LLMの回答"),
  sources: z.array(diarySourceSchema).describe("参照した日記のリスト"),
});

function buildContext(sources: DiarySource[]): string {
  if (sources.length === 0) {
    // ①
    return "関連する日記は見つかりませんでした。";
  }

  const contextParts = sources.map((source, index) => {
    // ②
    const date = source.date.slice(0, 10); // ISO 8601 → YYYY-MM-DD
    return `[${index + 1}] ${date}: ${source.content}`;
  });

  return contextParts.join("\n\n"); // ③
}

export const memoryAssistantFlow = ai.defineFlow(
  {
    name: "memoryAssistantFlow",
    inputSchema,
    outputSchema,
  },
  async (input, { context }) => {
    const uid = requireAuth(context);
    const { query } = input;
    const documents = await diaryRetrieverFlow({ uid, query }); // ①

    const sources: DiarySource[] = documents.map((doc) => ({
      date: doc.date,
      documentId: doc.documentId,
      content: doc.content,
    }));

    const additionalContext = buildContext(sources); // ②

    const response = await prompt({
      // ③
      query,
      context: additionalContext,
    });

    // LLMが引用した番号に基づいてフィルタリング
    const citedIndices: number[] = response.output?.citedIndices ?? [];
    const citedSources = filterCitedSources(sources, citedIndices); // ④

    return {
      answer: response.output?.answer ?? "回答を生成できませんでした。",
      sources: citedSources,
    };
  },
);

// `buildContext` の定義の後に追加
function filterCitedSources(
  sources: DiarySource[],
  citedIndices: number[],
): DiarySource[] {
  const citedSourceIndices = new Set(citedIndices); // ①
  return sources.filter((_, index) => citedSourceIndices.has(index + 1)); // ②
}

export function requireAuth(context: ActionContext | undefined): string {
  const auth = context?.auth; // ①
  if (!auth) {
    // ②
    throw new UserFacingError("UNAUTHENTICATED", "認証が必要です");
  }
  return auth.uid; // ③
}
