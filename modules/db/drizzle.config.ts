import { config } from "dotenv";
import { defineConfig } from "drizzle-kit";
import { Resource } from "sst";

config({ path: ".env" });
export default defineConfig({
	schema: "./src/schema.ts",
	out: "./migrations",
	dialect: "postgresql",
	dbCredentials: {
		url: Resource.DatabaseUrl.value,
	},
});
