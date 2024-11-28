import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { db } from "db";
import { Resource } from "sst";

export const auth = betterAuth({
	database: drizzleAdapter(db, {
		provider: "pg",
	}),
	socialProviders: {
		github: {
			clientId: Resource.GithubClientId.value,
			clientSecret: Resource.GithubClientSecret.value,
		},
	},
});
