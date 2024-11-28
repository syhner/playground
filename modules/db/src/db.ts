import { drizzle } from "drizzle-orm/neon-http";
import { neon } from "@neondatabase/serverless";
import { Resource } from "sst";

const sql = neon(
	`postgresql://${Resource.DatabaseCredentials.username}:${Resource.DatabaseCredentials.password}@${Resource.DatabaseCredentials.host}/${Resource.DatabaseCredentials.databaseCredentials}?sslmode=require`,
);
export const db = drizzle({ client: sql });
