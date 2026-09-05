import { z } from "genkit";

import { requireAuth } from "./auth";
import { diaryRetrieverFlow } from "./diary-retriever";
import { ai } from "../genkit";

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
    return "関連する日記は見つかりませんでした。";
  }

  const contextParts = sources.map((source, index) => {
    const date = source.date.slice(0, 10); // ISO 8601 → YYYY-MM-DD
    return `[${index + 1}] ${date}: ${source.content}`;
  });

  return contextParts.join("\n\n");
}

function filterCitedSources(
  sources: DiarySource[],
  citedIndices: number[],
): DiarySource[] {
  const citedSourceIndices = new Set(citedIndices);
  return sources.filter((_, index) => citedSourceIndices.has(index + 1));
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
    const documents = await diaryRetrieverFlow({ uid, query });

    const sources: DiarySource[] = documents.map((doc) => ({
      date: doc.date,
      documentId: doc.documentId,
      content: doc.content,
    }));

    const additionalContext = buildContext(sources);

    const response = await prompt({
      query,
      context: additionalContext,
    });

    // LLMが引用した番号に基づいてフィルタリング
    const citedIndices: number[] = response.output?.citedIndices ?? [];
    const citedSources = filterCitedSources(sources, citedIndices);

    return {
      answer: response.output?.answer ?? "回答を生成できませんでした。",
      sources: citedSources,
    };
  },
);
