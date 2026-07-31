import { z } from "genkit";

import { ai } from "../genkit";
import { sentimentSchema } from "../types";

const generateFeedbackPrompt = ai.prompt("generate-feedback");

const inputSchema = z.object({
  content: z.string().describe("日記の内容"),
  sentiment: sentimentSchema
    .describe("センチメント分析結果")
    .default("neutral"),
});

const outputSchema = z.object({
  feedback: z.string().describe("フィードバック内容"),
});

const streamSchema = z.string().describe("フィードバックのチャンク");

export const generateFeedbackFlow = ai.defineFlow(
  {
    name: "generateFeedbackFlow",
    inputSchema,
    streamSchema,
    outputSchema,
  },
  async (input, { sendChunk }) => {
    const { stream, response } = generateFeedbackPrompt.stream(input);

    for await (const chunk of stream) {
      sendChunk(chunk.text);
    }

    const { text: feedback } = await response;
    return { feedback };
  },
);
