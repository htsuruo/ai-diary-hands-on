import { googleAI } from "@genkit-ai/google-genai";
import { genkit } from "genkit";

import { sentimentSchema } from "./types";

export const ai = genkit({
  plugins: [googleAI()],
  model: googleAI.model("gemini-3.1-flash-lite"),
  promptDir: "./src/diary-feedback/prompts",
});

ai.defineSchema("SentimentSchema", sentimentSchema);
ai.defineHelper("eq", (a: string, b: string) => a === b);
