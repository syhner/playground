import type { SubjectPayload } from "@openauthjs/openauth/session";
import { subjects } from "./auth";

declare namespace App {
	interface Locals {
		subject?: SubjectPayload<typeof subjects>;
	}
}
