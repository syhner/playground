/// <reference path="./.sst/platform/config.d.ts" />

const AWS_REGION = "eu-central-1";

export default $config({
	app(input) {
		return {
			name: "saas-starter",
			removal: input?.stage === "production" ? "retain" : "remove",
			home: "aws",
			providers: {
				neon: {
					version: "0.6.3",
					apiKey: process.env.NEON_API_KEY,
				},
				random: "4.16.7",
				aws: {
					region: AWS_REGION,
				},
			},
		};
	},
	async run() {
		const betterAuthSecret = new random.RandomString("BetterAuthSecret", {
			length: 32,
		});
		const githubClientId = new sst.Secret("GithubClientId");
		const githubClientSecret = new sst.Secret("GithubClientSecret");

		const neonProject = new neon.Project("MyProject", {
			name: "saas-starter",
			regionId: `aws-${AWS_REGION}`,
			historyRetentionSeconds: 60 * 60 * 24, // max for free tier
		});
		const neonBranch = new neon.Branch("MyBranch", {
			projectId: neonProject.id,
			name: "dev",
		});
		const neonEndpoint = new neon.Endpoint("MyEndpoint", {
			branchId: neonBranch.id,
			projectId: neonProject.id,
		});
		const neonRole = new neon.Role("MyRole", {
			branchId: neonBranch.id,
			projectId: neonProject.id,
		});
		const neonDatabase = new neon.Database("MyDatabase", {
			branchId: neonBranch.id,
			ownerName: neonRole.name,
			projectId: neonProject.id,
		});

		const databaseCredentials = new sst.Linkable("DatabaseCredentials", {
			properties: {
				username: neonRole.name,
				password: neonRole.password,
				host: neonEndpoint.host,
				database: neonDatabase.name,
			},
		});

		const backend = new sst.aws.Function("Backend", {
			url: true,
			handler: "modules/backend/src/index.handler",
			link: [databaseCredentials, githubClientId, githubClientSecret],
			environment: {
				BETTER_AUTH_SECRET: betterAuthSecret.result,
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
			link: [databaseCredentials],
		});
	},
});
