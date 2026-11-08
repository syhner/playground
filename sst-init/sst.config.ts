/// <reference path="./.sst/platform/config.d.ts" />
import { readdirSync } from "fs";
export default $config({
	app(input) {
		return {
			name: "saas-starter",
			removal: input?.stage === "production" ? "retain" : "remove",
			home: "aws",
		};
	},
	async run() {
		const outputs = {};
		for (const value of readdirSync("./modules/sst/")) {
			const result = await import("./modules/sst/" + value);
			if (result.outputs) Object.assign(outputs, result.outputs);
		}
		return outputs;
	},
});
