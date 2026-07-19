import { z } from "genkit";
import { ai } from "../../genkit";

import { sentimentSchema } from "../types";
import { analyzeSentimentFlow } from "./analyze-sentiment";
import { generateFeedbackFlow } from "./generate-feedback";

const inputSchema = z.object({
  content: z.string().describe("日記の内容"),
});

const outputSchema = z.object({
  sentiment: sentimentSchema.describe("センチメント分析結果"),
  feedback: z.string().describe("AIからのフィードバック"),
});

const streamSchema = z.string().describe("フィードバックのチャンク");

export const diaryFeedbackFlow = ai.defineFlow(
  {
    name: "diaryFeedbackFlow",
    inputSchema,
    streamSchema,
    outputSchema,
  },
  async (input, { sendChunk }) => {
    // Step 1: センチメント分析フローを実行
    const { sentiment } = await analyzeSentimentFlow(input);

    // Step 2: センチメント分析の結果を使ってフィードバック生成フローを実行
    const { stream, output } = generateFeedbackFlow.stream({
      content: input.content,
      sentiment,
    });

    // チャンクを取得
    for await (const chunk of stream) {
      sendChunk(chunk);
    }
    // 最終出力を取得
    const feedback = (await output).feedback;

    return { sentiment, feedback };
  },
);
