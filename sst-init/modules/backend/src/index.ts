import { Hono } from "hono";
import { Math } from "core";
import { handle } from "hono/aws-lambda";
// import { db } from "db";
// import { user } from "db/schema";

const api = new Hono();

api.get("/", (c) => {
	return c.text("Hello Hono!");
});

// api.get("/users", async (c) => {
// 	const users = await db.select().from(user);
// 	return c.json(users);
// });

api.get("/add/:a/:b", async (c) => {
	const a = parseInt(c.req.param("a"));
	const b = parseInt(c.req.param("b"));
	return c.text(Math.add(a, b).toString());
});

export const handler = handle(api);
