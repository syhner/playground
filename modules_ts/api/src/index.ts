import { echo } from "./routes/echo";
import { openapi } from "./routes/openapi";
import { Resource } from "sst";

export const api = openapi
  .get("/", (c) => {
    console.log({
      event: c.env.event,
      context: c.env.context,
    });

    // Use the SST SDK to access resources
    console.log(`Resource.Linkable.foo: ${Resource.Linkable.foo}`);

    return c.text("hello world");
  })
  .route("/echo", echo);
