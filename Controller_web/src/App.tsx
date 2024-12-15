import { useFullscreen } from "@mantine/hooks";
import { useEffect, useState } from "react";
import { Controller } from "./Controller/Controller";
import { Menu } from "./Menu";

export type links = "main" | "controller";

export function App() {
  const [view, setView] = useState<links>("controller");
  const { toggle, fullscreen } = useFullscreen();

  document.addEventListener(
    "dblclick",
    (event) => {
      event.preventDefault();
    },
    { passive: false }
  );

  // Prevent pinch-zoom
  document.addEventListener(
    "gesturestart",
    (event) => {
      event.preventDefault();
    },
    { passive: false }
  );

  // Prevent touch scrolling
  document.addEventListener(
    "touchmove",
    (event) => {
      event.preventDefault();
    },
    { passive: false }
  );

  useEffect(() => {
    if (view == "main" && fullscreen) {
      toggle();
    }
  }, [fullscreen, toggle, view]);

  if (view == "main") {
    return (
      <Menu
        setMenu={(url) => {
          setView(url);
        }}
      />
    );
  }

  // if (view == "controller") {
  return (
    <Controller
      setMenu={() => {
        setView("main");
      }}
    />
  );
  // }
}
