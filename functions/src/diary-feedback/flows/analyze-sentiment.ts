import { z } from "genkit";

import { ai } from "../genkit";
import { sentimentSchema } from "../types";

const analyzeSentimentPrompt = ai.prompt("analyze-sentiment");

const inputSchema = z.object({
  content: z.string().describe("日記の内容"),
});

const outputSchema = z.object({
  sentiment: sentimentSchema.describe("センチメント分析結果"),
});

// センチメント分析フロー
export const analyzeSentimentFlow = ai.defineFlow(
  {
    name: "analyzeSentimentFlow",
    inputSchema,
    outputSchema,
  },
  async (input) => {
    const response = await analyzeSentimentPrompt({ content: input.content });

    if (!response.output) {
      throw new Error("AI response has no output");
    }

    return response.output;
  },
);
