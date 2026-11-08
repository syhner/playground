import { describe, expect, test } from "vitest";
import { echo } from ".";

describe("Example", () => {
  test("should echo", () => {
    expect(echo("foo")).toBe("foo");
  });
});
