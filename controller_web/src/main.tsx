import { createRoot } from "react-dom/client";
import { App } from "./App";
import { createTheme, MantineProvider } from "@mantine/core";

// core styles are required for all packages
import "@mantine/core/styles.css";

const theme = createTheme({
  primaryColor: "grape",
  /** Put your mantine theme override here */
});

createRoot(document.getElementById("root")!).render(
  // <StrictMode>
  <MantineProvider theme={theme} defaultColorScheme="dark">
    <App />
  </MantineProvider>
  // </StrictMode>
);
