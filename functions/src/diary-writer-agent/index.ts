import { skills } from "@genkit-ai/middleware";
import { z } from "genkit";

import { requireAuth } from "../memory-assistant-rag/auth";
import { ai } from "./genkit";
// diary_draft.prompt が名前で参照するツールを登録するために読み込む。
import "./tools/recall_past_diaries";

const SKILL_PATHS = ["./src/diary-writer-agent/skills"];

const draftPrompt = ai.prompt("diary_draft");
const reflectPrompt = ai.prompt("diary_reflect");
const metaPrompt = ai.prompt("diary_meta");

const inputSchema = z.object({
  memo: z.string().describe("その日のできごとのラフなメモ書き"),
});

const outputSchema = z.object({
  diary: z.string().describe("整えられた日記本文"),
  title: z.string().describe("日記のタイトル"),
  moodTags: z.array(z.string()).describe("その日の気分を表すタグ（最大3つ）"),
});

const streamSchema = z.string().describe("最終的な日記本文のチャンク");

export const writeDiaryFlow = ai.defineFlow(
  {
    name: "writeDiaryFlow",
    inputSchema,
    outputSchema,
    streamSchema,
  },
  async ({ memo }, { context, sendChunk }) => {
    const uid = requireAuth(context);

    // Step 1: 下書き（ツールループ）
    const draft = await draftPrompt(
      { memo },
      {
        use: [skills({ skillPaths: SKILL_PATHS })],
        context: { uid },
        maxTurns: 6,
      },
    );

    // Step 2: レビューと推敲（reflection）。最終本文をストリーミング
    const { stream, response } = reflectPrompt.stream(
      { memo, draft: draft.text },
      { use: [skills({ skillPaths: SKILL_PATHS })], maxTurns: 4 },
    );
    for await (const chunk of stream) {
      sendChunk(chunk.text);
    }
    const refined = await response;

    // Step 3: メタデータ抽出（モデル選択）
    const meta = await metaPrompt({ diary: refined.text });

    return {
      diary: refined.text,
      title: meta.output?.title ?? "",
      moodTags: meta.output?.moodTags ?? [],
    };
  },
);
