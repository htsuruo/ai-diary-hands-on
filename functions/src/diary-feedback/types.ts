import { z } from "genkit";

export const sentimentSchema = z
  .enum(["positive", "neutral", "negative"])
  .describe("センチメント");

export type Sentiment = z.infer<typeof sentimentSchema>;
