import { googleAI } from "@genkit-ai/google-genai";
import { skills } from "@genkit-ai/middleware";
import { genkit } from "genkit";

import { sentimentSchema } from "./diary-feedback/types";

export const ai = genkit({
  plugins: [googleAI(), skills.plugin()],
  model: googleAI.model("gemini-3.5-flash-lite"),
  promptDir: "./src/prompts",
});

ai.defineSchema("SentimentSchema", sentimentSchema);
ai.defineHelper("eq", (a: string, b: string) => a === b);
