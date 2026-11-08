import { authorizer } from "@openauthjs/openauth";
import { handle } from "hono/aws-lambda";
import { subjects } from "./subjects";
import { PasswordAdapter } from "@openauthjs/openauth/adapter/password";
import { PasswordUI } from "@openauthjs/openauth/ui/password";
import { GithubAdapter } from "@openauthjs/openauth/adapter/github";
import { Resource } from "sst";

const app = authorizer({
	subjects,
	providers: {
		github: GithubAdapter({
			clientID: Resource.GithubClientId.value,
			clientSecret: Resource.GithubClientSecret.value,
			scopes: ["user:email"],
		}),
		password: PasswordAdapter(
			PasswordUI({
				sendCode: async (email, code) => {
					console.log(email, code);
				},
			}),
		),
	},
	success: async (ctx, value) => {
		if (value.provider === "password") {
			return ctx.subject("user", {
				email: value.email,
			});
		}
		if (value.provider === "github") {
			const emails = await fetch("https://api.github.com/user/emails", {
				headers: {
					Authorization: `Bearer ${value.tokenset.access}`,
				},
			}).then((res) => res.json());
			const primaryEmail = emails.find((email) => email.primary);

			return ctx.subject("user", {
				email: primaryEmail.email,
			});
		}
		throw new Error("Invalid provider");
	},
});

export const handler = handle(app);
