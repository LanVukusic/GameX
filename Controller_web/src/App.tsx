import { useFullscreen } from "@mantine/hooks";
import { useEffect, useState } from "react";
import { Controller } from "./Controller/Controller";
import { Menu } from "./Menu";
import React from "react";
import {
  DndContext,
  MouseSensor,
  TouchSensor,
  useSensor,
  useSensors,
} from "@dnd-kit/core";

export type links = "main" | "controller";

export function App() {
  const [view, setView] = useState<links>("main");
  const { toggle, fullscreen } = useFullscreen();
  const mouseSensor = useSensor(MouseSensor);
  const touchSensor = useSensor(TouchSensor);

  const sensors = useSensors(mouseSensor, touchSensor);

  useEffect(() => {
    if (view == "main" && fullscreen) {
      toggle();
    }
  }, [fullscreen, toggle, view]);

  // if (view == "main") {
  //   return (
  //     <Menu
  //       setMenu={(url) => {
  //         setView(url);
  //       }}
  //     />
  //   );
  // }

  // if (view == "controller") {
  return (
    <DndContext sensors={sensors}>
      <Controller
        setMenu={() => {
          setView("main");
        }}
      />
    </DndContext>
  );
  // }
}
