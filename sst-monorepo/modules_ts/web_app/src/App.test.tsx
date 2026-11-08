import { describe, expect, it } from "vitest";
import userEvent from "@testing-library/user-event";
import { render, screen } from "@testing-library/react";
import App from "./App";

describe("App", () => {
  it("renders the header correctly", async () => {
    render(<App />);

    await userEvent.click(screen.getByTestId("count-button"));

    expect(screen.getByRole("heading")).toHaveTextContent("Vite + React");
  });

  it("the count should initially be 0. when the count button is clicked, the count should increment", async () => {
    render(<App />);

    expect(screen.getByTestId("count-button")).toHaveTextContent("count is 0");

    const button = screen.getByTestId("count-button");
    for (let i = 0; i < 3; i++) {
      await userEvent.click(button);
    }

    expect(button).toHaveTextContent("count is 3");
  });
});
