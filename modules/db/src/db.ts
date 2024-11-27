import { drizzle } from "drizzle-orm/neon-http";
import { neon } from "@neondatabase/serverless";
import { config } from "dotenv";
import { Resource } from "sst";

config({ path: ".env" });

const sql = neon(Resource.DatabaseUrl.value);
export const db = drizzle({ client: sql });
