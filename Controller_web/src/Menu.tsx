import {
  useMantineTheme,
  Center,
  Stack,
  Title,
  TextInput,
  Button,
} from "@mantine/core";
import { PlayerColorPicker } from "./Components/PlayerColorPicker";
import { links } from "./App";
import { ThemedShadow } from "./Components/ThemedShadow";
import { $player, setName } from "./store/player";
import { useStore } from "@nanostores/react";

interface Props {
  setMenu: (arg: links) => void;
}

export const Menu = ({ setMenu }: Props) => {
  const theme = useMantineTheme();
  const player = useStore($player);

  return (
    <>
      <ThemedShadow />
      <Center h="100vh">
        <Stack p="xl">
          <Title size="3rem" c={theme.primaryColor}>
            Game X
          </Title>
          <TextInput
            placeholder="Display name"
            size="xl"
            value={player.name}
            onChange={(ev) => {
              setName(ev.target.value);
            }}
          />
          <PlayerColorPicker />
          <Button
            onClick={() => {
              setMenu("controller");
            }}
            disabled={!(player.name.length > 1)}
          >
            Connect
          </Button>
        </Stack>
      </Center>
    </>
  );
};
