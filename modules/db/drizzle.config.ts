import { defineConfig } from "drizzle-kit";
import { Resource } from "sst";

export default defineConfig({
	schema: "./src/schema.ts",
	out: "./migrations",
	dialect: "postgresql",
	dbCredentials: {
		url: `postgresql://${Resource.DatabaseCredentials.username}:${Resource.DatabaseCredentials.password}@${Resource.DatabaseCredentials.host}/${Resource.DatabaseCredentials.databaseCredentials}?sslmode=require`,
	},
});
