import { googleAI } from "@genkit-ai/google-genai";

const outputDimensionality = 768;
const embeddingModel = "gemini-embedding-001";

// ドキュメントインデックス用Embedder
export const documentEmbedder = googleAI.embedder(embeddingModel, {
  taskType: "RETRIEVAL_DOCUMENT",
  outputDimensionality,
});

// 検索クエリ用Embedder
export const queryEmbedder = googleAI.embedder(embeddingModel, {
  taskType: "RETRIEVAL_QUERY",
  outputDimensionality,
});
