import { googleAI } from "@genkit-ai/google-genai";

const outputDimensionality = 768; // ①
const embeddingModel = "gemini-embedding-2";

// ドキュメントインデックス用Embedder
export const documentEmbedder = googleAI.embedder(embeddingModel, {
  // ②
  outputDimensionality,
});

// 10.5で使用する検索クエリ用Embedder
export const queryEmbedder = googleAI.embedder(embeddingModel, {
  // ③
  outputDimensionality,
});

export function formatDocumentForEmbedding({
  // ④
  title,
  content,
}: {
  title: string;
  content: string;
}): string {
  return `title: ${title} | text: ${content}`;
}

export function formatQueryForEmbedding(query: string): string {
  // ⑤
  return `task: search result | query: ${query}`;
}
