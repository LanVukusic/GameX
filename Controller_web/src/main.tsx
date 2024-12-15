import { createRoot } from "react-dom/client";
import "./main.css";

// core styles are required for all packages
import "@mantine/core/styles.css";
import { ColorLayout } from "./Components/ColorHandlerLayout";

createRoot(document.getElementById("root")!).render(<ColorLayout />);
