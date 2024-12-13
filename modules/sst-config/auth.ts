export const auth = new sst.aws.Auth("Auth", {
	authorizer: "modules/auth/src/index.handler",
});
