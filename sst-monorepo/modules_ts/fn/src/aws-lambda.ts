import type { Context, S3Event, APIGatewayProxyEvent } from "aws-lambda";
import { Example } from "@abtrace/core";
import { Resource } from "sst";

export const handler = async (event: APIGatewayProxyEvent, context: Context) => {
  console.log({
    event,
    context,
  });

  // Use the SST SDK to access resources
  console.log(`Resource.Linkable.foo: ${Resource.Linkable.foo}`);

  return Example.echo(event.queryStringParameters?.input!);
};
