import { backend } from "./backend";
import { databaseCredentials } from "./database";

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
