import { handle, type LambdaEvent, type LambdaContext } from "hono/aws-lambda";
import { api } from ".";

export type Bindings = {
  event: LambdaEvent;
  context: LambdaContext;
};

export const handler = handle(api);
