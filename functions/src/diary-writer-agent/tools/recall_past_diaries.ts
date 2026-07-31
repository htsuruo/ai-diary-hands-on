import { z } from "genkit";

import { ai } from "../../genkit";
import { diaryRetrieverFlow } from "../../memory-assistant-rag/diary-retriever";

export const recallPastDiaries = ai.defineTool(
  {
    name: "recallPastDiaries",
    description:
      "過去に書いた日記を意味検索で呼び出す。書き手の文体や口調、よく使う表現をつかんだり、メモに出てくる場所・人物・できごとに関連する過去の記録を思い出すために使う。",
    inputSchema: z.object({
      query: z
        .string()
        .describe("思い出したい話題・場所・感情などの検索クエリ"),
    }),
    outputSchema: z.string(),
  },
  async ({ query }, { context }) => {
    const uid = (context as { uid?: string }).uid;
    if (!uid) {
      return "ユーザーIDが指定されていないため、過去の日記を参照できませんでした。";
    }

    try {
      const documents = await diaryRetrieverFlow({
        uid,
        query,
      });
      if (documents.length === 0) {
        return "関連する過去の日記は見つかりませんでした。";
      }

      return documents
        .map((doc) => `【${doc.date}】${doc.content}`)
        .join("\n\n");
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return `過去の日記の参照中にエラーが発生しました（${message}）。過去の日記なしで執筆を続けてください。`;
    }
  },
);
