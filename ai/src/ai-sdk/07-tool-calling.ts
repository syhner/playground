import { streamText, tool } from "ai";
import { z } from "zod";
import { claude } from "./00-models";

const weatherTool = tool({
  description: "Get the weather for a location",
  parameters: z.object({
    city: z.string(),
  }),
  execute: async ({ city }) => {
    return `The weather in ${city} is sunny.`;
  },
});

const stream = streamText({
  model: claude,
  messages: [
    {
      role: "system",
      content: "You are a weather app. After using your tools, respond with the final answer.",
    },
    { role: "user", content: "What is the weather in New York?" },
  ],
  tools: {
    weatherTool,
  },
  maxSteps: 2, // feed tool results back into llm to create an 'agent'
});

for await (const text of stream.textStream) {
  process.stdout.write(text);
}

const steps = await stream.steps;
const toolCalls = await stream.toolCalls;
const toolResults = await stream.toolResults;
