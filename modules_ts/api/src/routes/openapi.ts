import { swaggerUI } from "@hono/swagger-ui";
import { hono } from "../hono";

export const openapi = hono()
  .doc("/openapi.json", {
    openapi: "3.0.0",
    info: {
      version: "1.0.0",
      title: "API",
    },
  })
  .get("/docs", swaggerUI({ url: "/openapi.json" }));
