import { z } from "genkit";
import { ai } from "../../genkit"; // インポートを追加
import { sentimentSchema } from "../types"; // インポートを追加

const generateFeedbackPrompt = ai.prompt("diary-feedback/generate-feedback");

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
    name: "generateFeedback",
    inputSchema,
    streamSchema,
    outputSchema,
  },
  async (input, { sendChunk }) => {
    // const { content, sentiment } = input;
    // 感情に応じたトーン指示を生成
    // const toneInstructions = getToneInstructions(sentiment);

    //     const systemPrompt = `あなたは親しみやすい日記アシスタントです。
    // ユーザーの日記を読んで、以下のトーン指示を参考に共感的なフィードバックを提供してください。

    // ${toneInstruction}

    // フィードバックは3~5文程度で書いてください。また、絵文字は一切使わないでください。`;

    // ===シンプル出力
    // const { text } = await ai.generate({
    //   system: systemPrompt,
    //   prompt: `次の日記にフィードバックしてください：\n\n${input.content}`,
    // });

    // return { feedback: text };

    // ===ストリーミング出力
    // const { stream, response } = ai.generateStream({

    //   system: systemPrompt,
    //   prompt: `次の日記にフィードバックしてください：\n\n${input.content}`,
    // });

    // ===Dotpromptを使ったストリーミング出力
    const { stream, response } = generateFeedbackPrompt.stream(input);

    for await (const chunk of stream) {

      sendChunk(chunk.text);
    }

    const { text: feedback } = await response;
    return { feedback };
  },
);

// function getToneInstructions(sentiment: Sentiment): string {
//   switch (sentiment) {
//     case "positive":
//       return `【トーン指示】
// ユーザーは良い気分です。一緒に喜び、明るく元気なテンションで応答してください。
// 「素敵ですね！」「よかったですね！」など、ポジティブな表現を使ってください。`;

//     case "negative":
//       return `【トーン指示】
// ユーザーは落ち込んでいるか、つらい状況にあります。
// 寄り添うような優しいトーンで、励ましの言葉を添えてください。
// 「大変でしたね」「無理しないでくださいね」など、共感と労いの表現を使ってください。`;

//     case "neutral":
//     default:
//       return `【トーン指示】
// ユーザーは平常な気分です。落ち着いた穏やかなトーンで応答してください。
// 日記の内容に軽くコメントし、日常の小さな発見を認めるような表現を使ってください。`;
//   }
// }
