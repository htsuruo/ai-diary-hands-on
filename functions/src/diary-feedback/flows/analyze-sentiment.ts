import { z } from "genkit";

import { ai } from "../../genkit"; // インポートを追加
import { sentimentSchema } from "../types"; // インポートを追加

const analyzeSentimentPrompt = ai.prompt("diary-feedback/analyze-sentiment");


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
    // const response = await ai.generate({
    //   system: `あなたは優秀な感情分析アシスタントです。与えられた日記の内容に基づいて、その感情がpositive・neutral・negativeのいずれかであると判断してください。`,
    //   prompt: `内容:\n${input.content}`,
    //   output: {

    //     schema: z.object({
    //       sentiment: sentimentSchema,
    //     }),
    //   },
    // });

    const response = await analyzeSentimentPrompt({ content: input.content });

    if (!response.output) {
      throw new Error("AI response has no output");
    }

    return response.output;
  },
);
