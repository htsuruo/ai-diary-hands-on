import { googleAI } from "@genkit-ai/google-genai";
import { genkit } from "genkit";

export const ai = genkit({
  plugins: [googleAI()],
  model: googleAI.model("gemini-3.1-flash-lite"),
  promptDir: "./src/memory-assistant-rag/prompts",
});
