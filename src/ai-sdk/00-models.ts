import { anthropic } from "@ai-sdk/anthropic";
import { createOpenAICompatible } from "@ai-sdk/openai-compatible";

const lmStudio = createOpenAICompatible({
  name: "lmstudio",
  baseURL: `http://localhost:1234/v1`,
});

export const lmModel = lmStudio(""); // selected model in LM Studio
export const lmEmbeddingModel = lmStudio.textEmbeddingModel(""); // selected embedding model in LM Studio
export const claude = anthropic("claude-3-5-haiku-latest");
export const gpt = anthropic("gpt-3.5-turbo");
