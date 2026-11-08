import { describe, expect, test, vi } from "vitest";
import { api } from "../index";
import { testClient } from "hono/testing";

describe("echo routes", () => {
  test("should echo the input (using api.request)", async () => {
    const res = await api.request("/echo?input=42");
    expect(res.status).toBe(200);
    expect(await res.text()).toBe("42");
  });

  test("should echo the input (using Request)", async () => {
    const req = new Request("http://localhost/echo?input=42", {
      method: "GET",
    });
    const res = await api.request(req);
    expect(res.status).toBe(200);
    expect(await res.text()).toBe("42");
  });

  test("should echo the input (using testClient)", async () => {
    const client = testClient(api);
    const res = await client.echo.$get({ query: { input: "42" } });
    expect(res.status).toBe(200);
    expect(await res.text()).toBe("42");
  });
});
