import { createApiClient } from "@abtrace/openapi";

export const api = createApiClient(import.meta.env.VITE_ROUTER_URL);
