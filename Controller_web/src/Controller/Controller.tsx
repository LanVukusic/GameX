import {
  Stack,
  LoadingOverlay,
  Group,
  ActionIcon,
  TextInput,
  Grid,
  Button,
  SegmentedControl,
  Center,
  Title,
  useMantineTheme,
} from "@mantine/core";
import {
  IconSettings,
  IconMinimize,
  IconMaximize,
  IconBolt,
  IconBulb,
  IconChevronLeft,
  IconDots,
} from "@tabler/icons-react";
import { ReadyState } from "react-use-websocket";
import { ThemedJoystick } from "../Components/ThemedJoystick";
import { ThemedShadow } from "../Components/ThemedShadow";
import { useFullscreen } from "@mantine/hooks";
import { useGameSocket } from "../WebsocketLogic";
import { LoaderContent } from "./Loader";
import { $player } from "../store/player";
import { useStore } from "@nanostores/react";
import { useEffect } from "react";

const THROTTLE = 10; // ms for debounce

interface Props {
  setMenu: () => void;
}

export const Controller = ({ setMenu }: Props) => {
  const { toggle, fullscreen } = useFullscreen();
  const { readyState, sendMsg } = useGameSocket();
  const player = useStore($player);
  const theme = useMantineTheme();
  const hex = theme.colors[player.color];

  useEffect(() => {
    if (readyState == ReadyState.OPEN) {
      sendMsg({
        t: "join",
        name: player.name,
        color: hex[4],
      });
    }
  }, [hex, player.name, readyState, sendMsg]);

  return (
    <Stack
      h="100vh"
      justify="stretch"
      p="0"
      m="0"
      style={{
        overflow: "hidden",
      }}
      pos="relative"
    >
      <LoadingOverlay
        visible={readyState != ReadyState.OPEN}
        overlayProps={{
          blur: 15,
          opacity: 0.9,
        }}
        loaderProps={{ children: <LoaderContent setMenu={setMenu} /> }}
      />
      <ThemedShadow />
      <Group wrap="nowrap" p="xs" pb="0">
        <ActionIcon variant="subtle" onClick={setMenu}>
          <IconChevronLeft />
        </ActionIcon>
        <ActionIcon variant="subtle">
          <IconSettings />
        </ActionIcon>

        <TextInput w="100%" value={player.name} readOnly />
        <ActionIcon onClick={toggle} variant="light">
          {fullscreen ? <IconMinimize /> : <IconMaximize />}
        </ActionIcon>
        {/* <ActionIcon variant="subtle">
          <ThemeIndicator />
        </ActionIcon> */}
      </Group>
      <Grid
        justify="flex-start"
        align="stretch"
        h="100%"
        styles={{
          inner: {
            height: "100%",
          },
        }}
      >
        <Grid.Col span={3} h="100%">
          <Stack h="100%" justify="space-around" align="center" py="md">
            <Button leftSection={<IconBolt />} variant="light">
              Reload
            </Button>
            <Button leftSection={<IconDots />} variant="light">
              Fire
            </Button>
            <ThemedJoystick
              size={100}
              stop={() => {
                sendMsg({
                  t: "move",
                  x: 0.0,
                  y: 0.0,
                });
              }}
              throttle={THROTTLE}
              sticky={false}
              move={(data) => {
                sendMsg({
                  t: "move",
                  x: data.x || 0,
                  y: data.y || 0,
                });
              }}
            />
          </Stack>
        </Grid.Col>
        <Grid.Col span={6}>
          <Stack h="100%">
            <SegmentedControl fullWidth data={["Inventory", "Map", "Stats"]} />
            <Center w="100%" h="100%" bg="blue.1" opacity={0.1}>
              <Title> TODO</Title>
            </Center>
          </Stack>
        </Grid.Col>
        <Grid.Col span={3}>
          <Stack h="100%" justify="space-around" align="center" py="md">
            <Button
              leftSection={<IconBulb />}
              variant="subtle"
              onClick={() => {
                sendMsg({
                  t: "light",
                });
              }}
            >
              Light
            </Button>
            <ThemedJoystick
              size={100}
              sticky={false}
              throttle={THROTTLE}
              move={(data) => {
                sendMsg({
                  t: "look",
                  x: data.x || 0,
                  y: data.y || 0,
                });
              }}
            />
          </Stack>
        </Grid.Col>
      </Grid>
    </Stack>
  );
};
