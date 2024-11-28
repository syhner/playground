/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
	app(input) {
		return {
			name: "saas-starter",
			removal: input?.stage === "production" ? "retain" : "remove",
			home: "aws",
			providers: { random: "4.16.7" },
		};
	},
	async run() {
		const DatabaseUrl = new sst.Secret("DatabaseUrl");
		const BetterAuthSecret = new random.RandomString("BetterAuthSecret", {
			length: 32,
		});
		const GithubClientId = new sst.Secret("GithubClientId");
		const GithubClientSecret = new sst.Secret("GithubClientSecret");

		const backend = new sst.aws.Function("Backend", {
			url: true,
			handler: "modules/backend/src/index.handler",
			link: [DatabaseUrl, BetterAuthSecret, GithubClientId, GithubClientSecret],
			environment: {
				BETTER_AUTH_SECRET: BetterAuthSecret.result,
			},
		});

		new sst.x.DevCommand("MobileApp", {
			dev: {
				autostart: true,
				directory: "modules/mobile-app",
				command: "pnpm start",
			},
			environment: {
				EXPO_PUBLIC_API_URL: backend.url,
			},
		});

		new sst.x.DevCommand("Db", {
			dev: {
				autostart: true,
				directory: "modules/db",
				command: "pnpm run studio",
			},
			link: [DatabaseUrl],
		});
	},
});
