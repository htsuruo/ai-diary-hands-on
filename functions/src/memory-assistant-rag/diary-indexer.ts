import { FieldValue } from "firebase-admin/firestore";
import { z } from "genkit"; // ①
import { Document } from "genkit/retriever";
import { db } from "../firebase";
import { ai } from "../genkit"; // ②
import { documentEmbedder, formatDocumentForEmbedding } from "./embedder";
import { loadSampleDiaries } from "./sample-diaries";

type IndexerMetadata = {
  title: string;
  date: string;
};

export const diaryIndexer = ai.defineIndexer(
  // ③
  {
    name: "diaryIndexer",
    configSchema: z.object({
      // ④
      uid: z.string().describe("ユーザーID"),
    }),
  },
  async (docs, options) => {
    const batch = db.batch();
    const uid = options?.uid;
    const collectionRef = db.collection("users").doc(uid).collection("diaries");

    for (const doc of docs) {
      const docRef = collectionRef.doc();
      const meta = (doc.metadata as IndexerMetadata) ?? {};

      const [{ embedding }] = await ai.embed({
        embedder: documentEmbedder, // ②
        content: formatDocumentForEmbedding({
          title: meta.title,
          content: doc.text,
        }),
      });

      batch.set(docRef, {
        // ③
        title: meta.title,
        content: doc.text,
        feedback: null,
        sentimentAnalysis: null,
        date: meta.date,
        embedding: FieldValue.vector(embedding),
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
    }
    await batch.commit(); // ④
  },
);

const inputSchema = z.object({
  uid: z.string().describe("ユーザーID"),
  clearAll: z
    .boolean()
    .default(false)
    .describe("既存のデータを削除してから生成する"),
});

const outputSchema = z.object({ count: z.number() });

// `inputSchema` と `outputSchema` の定義の後に追加
export const diaryIndexerFlow = ai.defineFlow(
  {
    name: "diaryIndexerFlow",
    inputSchema,
    outputSchema,
  },
  async (input) => {
    const uid = input.uid;
    if (input.clearAll) {
      await db.recursiveDelete(
        db.collection("users").doc(uid).collection("diaries"),
      ); // ①
    }

    const sampleDiaries = loadSampleDiaries(); // ②
    const documents = sampleDiaries.map((diary) =>
      Document.fromText(diary.content, {
        // ③
        title: diary.title,
        date: diary.date,
      }),
    );

    await ai.index({
      // ④
      indexer: diaryIndexer,
      documents,
      options: { uid },
    });

    return { count: documents.length };
  },
);
