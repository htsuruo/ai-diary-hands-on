import { googleAI } from "@genkit-ai/google-genai";

const outputDimensionality = 768;
const embeddingModel = "gemini-embedding-2";

// ドキュメントインデックス用Embedder
export const documentEmbedder = googleAI.embedder(embeddingModel, {
  outputDimensionality,
});

export function formatDocumentForEmbedding({
  title,
  content,
}: {
  title: string;
  content: string;
}): string {
  return `title: ${title} | text: ${content}`;
}

// 検索クエリ用Embedder
export const queryEmbedder = googleAI.embedder(embeddingModel, {
  outputDimensionality,
});

export function formatQueryForEmbedding(query: string): string {
  return `task: search result | query: ${query}`;
}
