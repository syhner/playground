import { auth } from "./auth";

const webApp = new sst.aws.Astro("WebApp", {
	path: "modules/web-app",
	link: [auth],
});
