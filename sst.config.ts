/// <reference path="./.sst/platform/config.d.ts" />
import { readdirSync } from "fs";
const AWS_REGION = "eu-central-1";
export default $config({
	app(input) {
		return {
			name: "saas-starter",
			removal: input?.stage === "production" ? "retain" : "remove",
			home: "aws",
			providers: {
				neon: {
					version: "0.6.3",
					apiKey: process.env.NEON_API_KEY,
				},
				random: "4.16.7",
				aws: {
					region: AWS_REGION,
				},
			},
		};
	},
	async run() {
		const outputs = {};
		for (const value of readdirSync("./modules/sst-config/")) {
			const result = await import("./modules/sst-config/" + value);
			if (result.outputs) Object.assign(outputs, result.outputs);
		}
		return outputs;
	},
});
