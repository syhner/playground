import { auth } from "./auth";
import { backend } from "./backend";
import { databaseCredentials } from "./database";

new sst.x.DevCommand("Mobile", {
	dev: {
		autostart: true,
		directory: "modules/mobile",
		command: "pnpm start",
	},
	environment: {
		EXPO_PUBLIC_API_URL: backend.url,
		EXPO_PUBLIC_AUTH_ISSUER: auth.url,
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
