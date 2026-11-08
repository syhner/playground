import { describe, it, expect, vi } from "vitest";
import type { Context, APIGatewayProxyEvent } from "aws-lambda";
import { handler } from "./aws-lambda";

describe("lambda", () => {
  it("should echo the input parameter", async () => {
    const mockEvent = {
      queryStringParameters: {
        input: 42,
      },
    } as unknown as APIGatewayProxyEvent;
    const mockContext = {} as Context;

    const response = await handler(mockEvent, mockContext);

    expect(response).toBe(42);
  });
});
