import createClient from "openapi-fetch";

import type { paths as GoApiPaths } from "./GoApi/openapi";
import type { paths as PyApiPaths } from "./PyApi/openapi";
import type { paths as TsApiPaths } from "./TsApi/openapi";
import type { Api } from "@abtrace/api";
import { hc } from "hono/client";

export const createApiClient = (routerUrl: string) => ({
  ts: createClient<TsApiPaths>({ baseUrl: `${routerUrl}/api/ts` }),
  tsHono: hc<Api>(`${routerUrl}/api/ts`),
  go: createClient<GoApiPaths>({ baseUrl: `${routerUrl}/api/go` }),
  py: createClient<PyApiPaths>({ baseUrl: `${routerUrl}/api/py` }),
  pyContainer: createClient<PyApiPaths>({ baseUrl: `${routerUrl}/api/py-container` }),
});
