import { Example } from "@abtrace/core";
import { createRoute, z } from "@hono/zod-openapi";
import { hono } from "../hono";

export const echo = hono().openapi(
  createRoute({
    method: "get",
    path: "/",
    request: { query: z.object({ input: z.coerce.string() }) },
    responses: {
      200: {
        content: { "text/plain": { schema: z.string() } },
        description: "Echo the number",
      },
    },
  }),
  (c) => c.text(Example.echo(c.req.valid("query").input)),
);
