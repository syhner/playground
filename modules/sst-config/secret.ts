export const betterAuthSecret = new random.RandomString("BetterAuthSecret", {
	length: 32,
});
export const githubClientId = new sst.Secret("GithubClientId");
export const githubClientSecret = new sst.Secret("GithubClientSecret");
