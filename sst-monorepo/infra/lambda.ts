import type { Output } from "@pulumi/pulumi";
import { exec } from "node:child_process";
import { link } from "./link";
import { readFileSync } from "node:fs";
import { vpc } from "./vpc";

const nodeVersion = readFileSync(".node-version", "utf8").trim();
const pythonVersion = readFileSync(".python-version", "utf8").trim();
$transform(sst.aws.Function, (args, opts, name) => {
  // Use handler path to automatically set lambda runtime
  const handler = args.handler.toString();
  if (handler.startsWith("modules_py")) {
    args.runtime ??= `python${pythonVersion}` as any;
  } else if (handler.startsWith("modules_ts")) {
    args.runtime ??= `nodejs${nodeVersion}.x` as any;
  } else if (handler.startsWith("modules_go")) {
    args.runtime ??= "go";
  }

  args.vpc ??= vpc.properties;
});

export const tsApi = new sst.aws.Function("TsApi", {
  handler: "modules_ts/api/src/aws-lambda.handler",
  url: true,
  link: [link],
});
generateOpenApi(tsApi);

export const tsFn = new sst.aws.Function("TsFn", {
  handler: "modules_ts/fn/src/aws-lambda.handler",
  url: true,
  link: [link],
});

export const pyApi = new sst.aws.Function("PyApi", {
  handler: "modules_py_api/src/modules_py_api/aws_lambda.handler",
  url: true,
  link: [link],
});
generateOpenApi(pyApi);

export const pyApiContainer = new sst.aws.Function("PyApiContainer", {
  handler: "modules_py_api/src/modules_py_api/aws_lambda.handler",
  url: true,
  link: [link],
  python: {
    container: true,
  },
});

export const pyFn = new sst.aws.Function("PyFn", {
  handler: "modules_py_fn/src/modules_py_fn/aws_lambda.handler",
  url: true,
  link: [link],
});

export const goApi = new sst.aws.Function("GoApi", {
  handler: "modules_go/api",
  url: true,
  link: [link],
});
generateOpenApi(goApi);

export const goFn = new sst.aws.Function("GoFn", {
  handler: "modules_go/fn",
  url: true,
  link: [link],
});

function generateOpenApi(component: { name: Output<string>; url: Output<string> }) {
  $resolve([component.name, component.url]).apply(([name, url]) => {
    // e.g. configname-hostname-TsApiFunction-randomstring -> TsApi
    const componentName = name.split("-").at(-2)?.split("Function").at(0);
    const outputDir = `modules_ts/openapi/${componentName}`;
    const outputFileJson = `${outputDir}/openapi.json`;
    const outputFileTs = `${outputDir}/openapi.ts`;

    exec(
      `mkdir -p ${outputDir} && \
       curl --output ${outputFileJson} ${url}openapi.json && \
       npx openapi-typescript ${outputFileJson} --output ${outputFileTs} && \
       npx prettier --write ${outputFileJson}`,
    );
  });
}
