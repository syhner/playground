import { auth } from "./auth";

const webApp = new sst.aws.Astro("Web", {
	path: "modules/web",
	link: [auth],
});
