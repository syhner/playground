import { OpenAPIHono } from "@hono/zod-openapi";
import type { Bindings } from "./aws-lambda";

export const hono = () => new OpenAPIHono<{ Bindings: Bindings }>();
