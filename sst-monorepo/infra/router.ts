import { goApi, goFn, pyApi, pyApiContainer, pyFn, tsApi, tsFn } from "./lambda";

export const router = new sst.aws.Router("Router");

const rewriteApi = {
  regex: "^/api/(.*)/(.*)$",
  to: "/$2",
};

router.route("/api/ts", tsApi.url, { rewrite: rewriteApi });
router.route("/api/ts-fn", tsFn.url, { rewrite: rewriteApi });
router.route("/api/py", pyApi.url, { rewrite: rewriteApi });
router.route("/api/py-container", pyApiContainer.url, { rewrite: rewriteApi });
router.route("/api/py-fn", pyFn.url, { rewrite: rewriteApi });
router.route("/api/go", goApi.url, { rewrite: rewriteApi });
router.route("/api/go-fn", goFn.url, { rewrite: rewriteApi });
