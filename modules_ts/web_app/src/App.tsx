import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import { api } from "./lib/api";

function App() {
  const [count, setCount] = useState(0);

  const typescriptApi = useApi("TypeScript API", () =>
    // or fetch(`${import.meta.env.VITE_ROUTER_URL}/api/ts/echo?input=${count}`)
    api.ts
      .GET("/echo", { params: { query: { input: count.toString() } } })
      .then(({ data, error }) => {
        if (error) throw error;
        return data.toString();
      }),
  );

  const typescriptFunction = useApi("TypeScript Function", () =>
    fetch(`${import.meta.env.VITE_ROUTER_URL}/api/ts-fn/?input=${count}`).then((res) => res.text()),
  );

  const pythonApi = useApi("Python API", () =>
    // or fetch(`${import.meta.env.VITE_ROUTER_URL}/api/py/echo?input=${count}`)
    api.py.GET("/echo", { params: { query: { input: count } } }).then(({ data, error }) => {
      if (error) throw error;
      return data.toString();
    }),
  );

  const pythonApiContainer = useApi("Python API Container", () =>
    // or fetch(`${import.meta.env.VITE_ROUTER_URL}/api/py-container/echo?input=${count}`)
    api.pyContainer
      .GET("/echo", { params: { query: { input: count } } })
      .then(({ data, error }) => {
        if (error) throw error;
        return data.toString();
      }),
  );

  const pythonFunction = useApi("Python Function", () =>
    fetch(`${import.meta.env.VITE_ROUTER_URL}/api/py-fn/?input=${count}`).then((res) => res.text()),
  );

  const goApi = useApi("Go API", () =>
    // or fetch(`${import.meta.env.VITE_ROUTER_URL}/api/go/echo?input=${count}`)
    api.go.GET("/echo", { params: { query: { input: count.toString() } } }).then((res) => {
      if (res.error) throw res.error;
      return res.data.message;
    }),
  );

  const goFunction = useApi("Go Function", () =>
    fetch(`${import.meta.env.VITE_ROUTER_URL}/api/go-fn/?input=${count}`).then((res) => res.text()),
  );

  const backends = [
    typescriptApi,
    typescriptFunction,
    pythonApi,
    pythonApiContainer,
    pythonFunction,
    goApi,
    goFunction,
  ] as const;

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button data-testid="count-button" onMouseDown={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "auto 1fr 1fr 1fr",
          rowGap: "8px",
          columnGap: "16px",
          width: "800px",
        }}
      >
        {backends.map(([name, response, loading, responseTimes, fetch]) => (
          <>
            <button disabled={loading} onMouseDown={fetch}>
              Fetch from {name}
            </button>

            <div style={{ opacity: Number(responseTimes.length > 0) }}>
              <pre style={{ margin: 0 }}>{response}</pre>
              <pre style={{ margin: 0 }}>{responseTimes.at(-1)}ms</pre>
            </div>

            <div style={{ opacity: Number(responseTimes.length > 1) }}>
              <pre style={{ margin: 0 }}>{responseTimes.length - 1} warm</pre>
              <pre style={{ margin: 0 }}>{average(responseTimes.slice(1))}ms</pre>
            </div>

            <div style={{ opacity: Number(responseTimes.length > 0) }}>
              <pre style={{ margin: 0 }}>cold?</pre>
              <pre style={{ margin: 0 }}>{responseTimes[0]}ms</pre>
            </div>
          </>
        ))}
      </div>
    </>
  );
}

const useApi = (name: string, cb: () => Promise<string>) => {
  const [response, setResponse] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);
  const [responseTimes, setResponseTimes] = useState<number[]>([]);

  const fetch = async () => {
    setLoading(true);
    if (!response) setResponse("response loading...");

    const start = performance.now();
    const res = await cb();
    const end = performance.now();

    const duration = Math.round(end - start);
    setResponseTimes([...responseTimes, duration]);

    setResponse(`echoed: ${res}`);
    setLoading(false);
  };

  return [name, response, loading, responseTimes, fetch] as const;
};

const average = (arr: number[]) => {
  return (arr.reduce((a, b) => a + b, 0) / arr.length).toFixed();
};

export default App;
