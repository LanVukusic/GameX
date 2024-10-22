import { useEffect, useState } from "react";
import {
  Button,
  Center,
  Stack,
  TextInput,
  Title,
  useMantineTheme,
} from "@mantine/core";
import { Controller } from "./Controller/Controller";
import { useFullscreen } from "@mantine/hooks";
import { PlayerColorPicker } from "./Components/PlayerColorPicker";

export function App() {
  const theme = useMantineTheme();

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
        <Stack p="xl">
          <Title size="3rem" c={theme.primaryColor}>
            Game X
          </Title>
          <TextInput />
          <PlayerColorPicker />
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
