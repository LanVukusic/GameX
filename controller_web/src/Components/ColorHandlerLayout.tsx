import { createTheme, MantineProvider } from "@mantine/core";
import { App } from "../App";
import { $player } from "../store/player";
import { useStore } from "@nanostores/react";
import { useMemo } from "react";

export const ColorLayout = () => {
  const player = useStore($player);

  const theme = useMemo(() => {
    return createTheme({
      primaryColor: player.color,
      /** Put your mantine theme override here */
    });
  }, [player.color]);

  return (
    <MantineProvider theme={theme} defaultColorScheme="dark">
      <App />
    </MantineProvider>
  );
};
