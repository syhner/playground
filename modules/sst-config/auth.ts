import { githubClientId, githubClientSecret } from "./secret";

export const auth = new sst.aws.Auth("Auth", {
	authorizer: {
		handler: "modules/auth/src/index.handler",
		link: [githubClientId, githubClientSecret],
	},
});
