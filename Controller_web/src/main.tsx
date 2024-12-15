import { createRoot } from "react-dom/client";
import "./main.css";

// core styles are required for all packages
import "@mantine/core/styles.css";
import { ColorLayout } from "./Components/ColorHandlerLayout";
import { touchFix } from "./touchFix";

// forces touch scrolling, zooming and gestures to be deisabled
touchFix();

createRoot(document.getElementById("root")!).render(<ColorLayout />);
