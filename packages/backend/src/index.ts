import { Hono } from "hono";
import { Math } from "core";

const app = new Hono();

app.get("/", (c) => {
	return c.text("Hello Hono!");
});

app.get("/add/:a/:b", async (c) => {
	const a = parseInt(c.req.param("a"));
	const b = parseInt(c.req.param("b"));
	return c.text(Math.add(a, b).toString());
});

export default app;
