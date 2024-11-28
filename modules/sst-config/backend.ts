import { databaseCredentials } from "./database";
import { betterAuthSecret, githubClientId, githubClientSecret } from "./secret";

export const backend = new sst.aws.Function("Backend", {
	url: true,
	handler: "modules/backend/src/index.handler",
	link: [databaseCredentials, githubClientId, githubClientSecret],
	environment: {
		BETTER_AUTH_SECRET: betterAuthSecret.result,
	},
});
