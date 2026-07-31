import { googleAI } from "@genkit-ai/google-genai";
import { skills } from "@genkit-ai/middleware";
import { genkit } from "genkit";

export const ai = genkit({
  plugins: [googleAI(), skills.plugin()],
  model: googleAI.model("gemini-3.5-flash"),
  promptDir: "./src/diary-writer-agent/prompts",
});
