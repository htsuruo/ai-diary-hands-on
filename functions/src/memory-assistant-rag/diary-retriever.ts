import { defineFirestoreRetriever } from "@genkit-ai/firebase";
import { z } from "genkit";
import { db } from "../firebase";
import { ai } from "../genkit";
import { formatQueryForEmbedding, queryEmbedder } from "./embedder";

type DiarySearchResult = {
  id: string;
  date: string;
  distance: number;
};

const inputSchema = z.object({
  uid: z.string().describe("ユーザーID"),
  query: z.string().describe("検索クエリ"),
});

const outputSchema = z.array(
  z.object({
    content: z.string().describe("日記の内容"),
    documentId: z.string().describe("ドキュメントID"),
    date: z.string().describe("作成日"),
    distance: z.number().describe("類似度スコア"),
  }),
);

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
    // メタデータとして取得するフィールドを指定
    metadataFields: ["date", "distance"],
  });
}

export const diaryRetrieverFlow = ai.defineFlow(
  {
    name: "diaryRetrieverFlow",
    inputSchema,
    outputSchema,
  },
  async (input) => {
    const documents = await ai.retrieve({
      // ①
      retriever: userDiaryRetriever(input.uid),
      query: formatQueryForEmbedding(input.query),
      options: { limit: 5 },
    });

    return documents.map((doc) => {
      const meta = doc.metadata as DiarySearchResult;
      return {
        // ②
        content: doc.text,
        documentId: meta.id,
        date: meta.date,
        distance: meta.distance ?? 0,
      };
    });
  },
);
