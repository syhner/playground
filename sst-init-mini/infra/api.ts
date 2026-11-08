import { bucket } from "./storage";

export const myApi = new sst.aws.Function("MyApi", {
  url: true,
  link: [bucket],
  handler: "modules/api/src/index.handler",
});
