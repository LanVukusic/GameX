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
  Text,
  useMantineTheme,
  Box,
} from "@mantine/core";
import {
  IconSettings,
  IconMinimize,
  IconMaximize,
  IconBulb,
  IconChevronLeft,
  IconRepeat,
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

const THROTTLE = 50; // ms for debounce

interface Props {
  setMenu: () => void;
}

export const Controller = ({ setMenu }: Props) => {
  const { toggle, fullscreen } = useFullscreen();
  const { sendMsg, readyState } = useGameSocket();
  // const readyState = ReadyState.OPEN;
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
    // only do it once
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [readyState]);

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
            <Stack align="center">
              <Text size="xl" opacity={0.2}>
                Move
              </Text>
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
            <Group w="100%" px="xs">
              <Button
                fullWidth
                leftSection={<IconRepeat />}
                variant="light"
                size="xs"
                onClick={() => {
                  sendMsg({
                    t: "reload",
                  });
                }}
              >
                Reload
              </Button>
              <Button
                component="div"
                mt="lg"
                fullWidth
                variant="light"
                size="xl"
                onTouchStart={() => {
                  console.log("active");
                  sendMsg({
                    t: "shoot",
                    state: "active",
                  });
                }}
                onTouchEnd={() => {
                  console.log("release");
                  sendMsg({
                    t: "shoot",
                    state: "release",
                  });
                }}
                onMouseDown={() => {
                  console.log("active");
                  sendMsg({
                    t: "shoot",
                    state: "active",
                  });
                }}
                onMouseUp={() => {
                  console.log("release");
                  sendMsg({
                    t: "shoot",
                    state: "release",
                  });
                }}
              >
                Shoot
              </Button>
            </Group>
            <Stack align="center">
              <Text size="xl" opacity={0.2}>
                Look
              </Text>

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
          </Stack>
        </Grid.Col>
      </Grid>
    </Stack>
  );
};
