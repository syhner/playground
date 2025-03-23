import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { mcpServer } from "./mcp-server";

const transport = new StdioServerTransport();
await mcpServer.connect(transport);
