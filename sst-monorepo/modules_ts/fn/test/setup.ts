import { vi } from "vitest";

vi.mock("sst", () => ({
  Resource: new Proxy({}, { get: () => ({}) }),
}));
