import { Hono } from "hono";
import { handle } from "hono/aws-lambda";
import { Example } from "../../core/src";
import { Resource } from "sst";

const api = new Hono().get("/", (c) => {
  return c.text(`${Example.hello()} Linked to ${Resource.MyBucket.name}.`);
});

export const handler = handle(api);
