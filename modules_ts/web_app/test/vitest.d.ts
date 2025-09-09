/* eslint-disable @typescript-eslint/no-empty-object-type */

import "vitest";
import type { TestingLibraryMatchers } from "@testing-library/jest-dom/matchers";

declare module "vitest" {
  interface Matchers<R = unknown> extends TestingLibraryMatchers<R, unknown> {}
}
