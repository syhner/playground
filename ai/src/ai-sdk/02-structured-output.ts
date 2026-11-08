import { streamObject } from "ai";
import { z } from "zod";
import { claude } from "./00-models";

const schema = z.object({
  recipe: z.object({
    ingredients: z.array(z.object({ ingredient: z.string(), amount: z.string() })),
    instructions: z.array(z.string()),
  }),
});

// Can use generateObject if you don't need to stream the response
const stream = streamObject({
  model: claude,
  messages: [
    {
      role: "system",
      content: `
        You are helping users create a recipe.
        Use British English variants for ingredients,
        i.e. Coriander over Cilantro.`,
    },
    { role: "user", content: "How do I make shakshuka?" },
  ],
  schema,
});

for await (const obj of stream.partialObjectStream) {
  console.clear();
  console.dir(obj, { depth: null });
}
console.clear();

const finalStructuredOutput = await stream.object;
console.log(finalStructuredOutput);
