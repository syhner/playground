import { databaseCredentials } from "./database";
import { githubClientId, githubClientSecret } from "./secret";

export const backend = new sst.aws.Function("Backend", {
	url: true,
	handler: "modules/backend/src/index.handler",
	link: [databaseCredentials, githubClientId, githubClientSecret],
});
