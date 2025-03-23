import { type CoreMessage, type LanguageModel, streamText } from "ai";
import { lmModel } from "./00-models";

export const messageHistory: CoreMessage[] = [
  {
    role: "user",
    content: "What is your name?",
  },
  {
    role: "assistant",
    content: "My name is HAL 9000.",
  },
];

// Can use generateText if you don't need to stream the response
const stream = streamText({
  model: lmModel,
  messages: [
    {
      role: "system",
      content: `Keep responses short and concise.`,
    },
    ...messageHistory,
    { role: "user", content: "What is the meaning of life?" },
  ],
});

for await (const text of stream.textStream) {
  process.stdout.write(text);
}

const finalText = await stream.text;
