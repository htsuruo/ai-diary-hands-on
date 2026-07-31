import { defineFirestoreRetriever } from "@genkit-ai/firebase";
import { z } from "genkit";

import { db } from "../../firebase";
import { queryEmbedder } from "../../memory-assistant-rag/embedder";
import { ai } from "../genkit";

type DiarySearchResult = {
  id: string;
  date: string;
  distance: number;
};

// 第10章と同じ Firestore のベクトルインデックスを参照する Retriever
function userDiaryRetriever(uid: string) {
  return defineFirestoreRetriever(ai, {
    name: "diaryRetriever",
    firestore: db,
    collection: `users/${uid}/diaries`,
    embedder: queryEmbedder,
    vectorField: "embedding",
    contentField: "content",
    distanceMeasure: "COSINE",
    distanceResultField: "distance",
    metadataFields: ["date", "distance"],
  });
}

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
      const documents = await ai.retrieve({
        retriever: userDiaryRetriever(uid),
        query,
        options: { limit: 5 },
      });
      if (documents.length === 0) {
        return "関連する過去の日記は見つかりませんでした。";
      }

      return documents
        .map((doc) => {
          const meta = doc.metadata as DiarySearchResult;
          return `[${meta.date}] ${doc.text}`;
        })
        .join("\n\n");
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      return `過去の日記の参照中にエラーが発生しました（${message}）。過去の日記なしで執筆を続けてください。`;
    }
  },
);
