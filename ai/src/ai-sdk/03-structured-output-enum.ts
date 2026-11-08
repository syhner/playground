import { generateObject } from "ai";
import { claude } from "./00-models";

const finalStructuredOutputEnum = await generateObject({
  model: claude,
  messages: [
    {
      role: "system",
      content: `You are a sentiment analyzer. Classify the sentiment of the text.`,
    },
    { role: "user", content: "I hate trains" },
  ],
  maxRetries: 0,
  output: "enum",
  enum: ["negative", "neutral", "positive"],
});

console.log(finalStructuredOutputEnum);
