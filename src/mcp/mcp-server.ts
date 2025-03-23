import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const createMcpServer = () => {
  const server = new McpServer({
    name: "Weather Service",
    version: "1.0.0",
  });

  server.tool("weatherTool", { city: z.string() }, async ({ city }) => ({
    content: [
      {
        type: "text",
        text: `The weather in ${city} is sunny.`,
      },
    ],
  }));

  const getPrompt = (path: string) => `
  Clean up the transcript in the file at ${path}
  Do not edit the words,
  only the formatting and any incorrect transcriptions.
  Turn long-form numbers to short-form:
  One hundred and twenty-three -> 123
  Three hundred thousand, four hundred and twenty-two -> 300,422
  Add punctuation where necessary.
  Wrap any references to code in backticks.
  Include links as-is - do not modify links.
  
  Common terms:
  LLM-as-a-judge
  ReAct
  Reflexion
  RAG
  Vercel
  `;

  server.prompt(
    "cleanTranscription",
    "Clean up a transcript file",
    { path: z.string() },
    async ({ path }) => ({
      messages: [{ role: "user", content: { type: "text", text: getPrompt(path) } }],
    })
  );

  return server;
};

export const mcpServer = createMcpServer();
