import type { SubjectPayload } from "@openauthjs/openauth/session";
import { subjects } from "./src/auth";

declare namespace App {
	interface Locals {
		subject?: SubjectPayload<typeof subjects>;
	}
}
