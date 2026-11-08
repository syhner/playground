import { streamText } from "ai";
import { claude } from "./00-models";

const imageUrl = "https://avatars.githubusercontent.com/u/71605633?v=4";
const image = new URL(imageUrl);

// const imagePath = "~/Downloads/avatar.png";
// const image = await readFile(imagePath);

const response = streamText({
  model: claude,
  messages: [
    {
      role: "system",
      content: `You are an image alt-description generator.`,
    },
    {
      role: "user",
      content: [{ type: "image", image }],
    },
  ],
});

for await (const text of response.textStream) {
  process.stdout.write(text);
}
