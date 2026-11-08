import { generateObject, streamObject } from "ai";
import { z } from "zod";
import { claude } from "./00-models";
import { readFile } from "fs/promises";

const schema = z.object({
  transactions: z.array(
    z
      .object({
        date: z.string().describe("date of transaction"),
        details: z.string().describe("transaction details"),
        amount: z
          .number()
          .describe("transaction amount (negative if paid out, positive if paid in)"),
        balance: z.number().describe("balance remaining after transactionl"),
      })
      .describe("a transaction")
  ),
});

const data = await readFile("/Users/siraj/repos/aihero/2018-09-06_Statement.pdf");

const stream = streamObject({
  model: claude,
  messages: [
    {
      role: "system",
      content: `
        You will recieve a bank statement.
        Please extract the data from the bank statement.`,
    },
    {
      role: "user",
      content: [
        {
          type: "file",
          mimeType: "application/pdf",
          data,
        },
      ],
    },
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
