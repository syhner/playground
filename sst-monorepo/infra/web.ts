import { router } from "./router";

new sst.aws.StaticSite("WebApp", {
  path: "modules_ts/web_app",
  dev: {
    autostart: true,
    command: "pnpm run dev",
  },
  build: {
    command: "pnpm run build",
    output: "dist",
  },
  environment: {
    VITE_ROUTER_URL: router.url,
  },
});
