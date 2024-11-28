import { AWS_REGION } from "./consts";

const neonProject = new neon.Project("MyProject", {
	name: "saas-starter",
	regionId: `aws-${AWS_REGION}`,
	historyRetentionSeconds: 60 * 60 * 24, // max for free tier
});

const neonBranch = new neon.Branch("MyBranch", {
	projectId: neonProject.id,
	name: "dev",
});

const neonEndpoint = new neon.Endpoint("MyEndpoint", {
	branchId: neonBranch.id,
	projectId: neonProject.id,
});

const neonRole = new neon.Role("MyRole", {
	branchId: neonBranch.id,
	projectId: neonProject.id,
});

const neonDatabase = new neon.Database("MyDatabase", {
	branchId: neonBranch.id,
	ownerName: neonRole.name,
	projectId: neonProject.id,
});

export const databaseCredentials = new sst.Linkable("DatabaseCredentials", {
	properties: {
		username: neonRole.name,
		password: neonRole.password,
		host: neonEndpoint.host,
		database: neonDatabase.name,
	},
});
