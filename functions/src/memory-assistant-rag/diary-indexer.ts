import { FieldValue } from "firebase-admin/firestore";
import { z } from "genkit";
import { Document } from "genkit/retriever";

import { db } from "../firebase";
import { documentEmbedder } from "./embedder";
import { ai } from "../genkit";
import { loadSampleDiaries } from "./sample-diaries";

type IndexerMetadata = {
  title: string;
  date: string;
};

export const diaryIndexer = ai.defineIndexer(
  {
    name: "diaryIndexer",
    configSchema: z.object({
      uid: z.string().describe("ユーザーID"),
    }),
  },
  async (docs, options) => {
    const batch = db.batch();
    const uid = options?.uid;
    const collectionRef = db
      .collection("users")
      .doc(uid)
      .collection("diaries");

    for (const doc of docs) {
      const docRef = collectionRef.doc();

      const [{ embedding }] = await ai.embed({
        embedder: documentEmbedder,
        content: doc.text,
      });

      const meta = (doc.metadata as IndexerMetadata) ?? {};

      batch.set(docRef, {
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

    await batch.commit();
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
      );
    }

    const sampleDiaries = loadSampleDiaries();
    const documents = sampleDiaries.map((diary) =>
      Document.fromText(diary.content, {
        title: diary.title,
        date: diary.date,
      }),
    );

    await ai.index({
      indexer: diaryIndexer,
      documents,
      options: { uid },
    });

    return { count: documents.length };
  },
);
