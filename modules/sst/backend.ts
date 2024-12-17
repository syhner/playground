import { databaseUrl, githubClientId, githubClientSecret } from "./secret";

export const backend = new sst.aws.Function("Backend", {
	url: true,
	handler: "modules/backend/src/index.handler",
	link: [databaseUrl, githubClientId, githubClientSecret],
});
