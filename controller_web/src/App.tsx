import { useEffect, useState } from "react";
import { Button, Center, Stack, Title } from "@mantine/core";
import { Controller } from "./Controller/Controller";
import { useFullscreen } from "@mantine/hooks";

export function App() {
  const [view, setView] = useState<"main" | "controller">("main");
  const { toggle, fullscreen } = useFullscreen();

  useEffect(() => {
    if (view == "main" && fullscreen) {
      toggle();
    }
  }, [fullscreen, toggle, view]);

  if (view == "main") {
    return (
      <Center h="100vh">
        <Stack>
          <Title size="3rem">Game X</Title>
          <Button
            onClick={() => {
              setView("controller");
            }}
          >
            Connect
          </Button>
        </Stack>
      </Center>
    );
  }

  if (view == "controller") {
    return (
      <Controller
        setMenu={() => {
          setView("main");
        }}
      />
    );
  }
}
