/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
	app(input) {
		return {
			name: "saas-starter",
			removal: input?.stage === "production" ? "retain" : "remove",
			home: "aws",
		};
	},
	async run() {
		const backend = new sst.aws.Function("Backend", {
			url: true,
			handler: "packages/backend/src/index.handler",
		});
	},
});
