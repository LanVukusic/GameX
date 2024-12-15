import {
  ActionIcon,
  Button,
  Grid,
  Group,
  Stack,
  useMantineTheme,
} from "@mantine/core";
import { useFullscreen } from "@mantine/hooks";
import { useStore } from "@nanostores/react";
import {
  IconBulb,
  IconChevronLeft,
  IconMaximize,
  IconMinimize,
  IconRepeat,
  IconSettings,
} from "@tabler/icons-react";
import { useCallback, useEffect } from "react";
import { ReadyState } from "react-use-websocket";
import { HoldableButton } from "../Components/HoldableButton/HoldableButton";
import { Inventory } from "../Components/Inventory/Inventory";
import { ThemedJoystick } from "../Components/Joysticks/ThemedJoystick";
import { useGameSocket } from "../WebsocketLogic";
import { $player } from "../store/player";
import { DndContext } from "@dnd-kit/core";
import { useSensorsSettings } from "../Components/DnD/UseSensors";

const THROTTLE = 10; // ms for debounce

interface Props {
  setMenu: () => void;
}

export const Controller = ({ setMenu }: Props) => {
  const { toggle, fullscreen } = useFullscreen();
  const { sendMsg, readyState } = useGameSocket();
  const sensors = useSensorsSettings();
  // const readyState = ReadyState.OPEN;

  const player = useStore($player);
  const theme = useMantineTheme();
  const hex = theme.colors[player.color];

  const activePressed = useCallback(() => {
    console.count("active");
    sendMsg({
      t: "shoot",
      state: "active",
    });
  }, [sendMsg]);

  const releasePressed = useCallback(() => {
    console.count("released");
    sendMsg({
      t: "shoot",
      state: "release",
    });
  }, [sendMsg]);

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
      {/* <LoadingOverlay
        visible={readyState != ReadyState.OPEN}
        overlayProps={{
          blur: 15,
          opacity: 0.9,
        }}
        loaderProps={{ children: <LoaderContent setMenu={setMenu} /> }}
      /> */}
      {/* <ThemedShadow /> */}

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
          <Stack h="100%" justify="space-around" align="center">
            <Group wrap="nowrap" p="xs" pb="0" w="100%" justify="space-around">
              <ActionIcon variant="subtle" onClick={setMenu}>
                <IconChevronLeft />
              </ActionIcon>
              <ActionIcon variant="subtle">
                <IconSettings />
              </ActionIcon>

              <ActionIcon onClick={toggle} variant="light">
                {fullscreen ? <IconMinimize /> : <IconMaximize />}
              </ActionIcon>
            </Group>
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
              <ThemedJoystick
                size={180}
                stickSize={40}
                throttle={THROTTLE}
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
            {/* <SegmentedControl fullWidth data={["Inventory", "Map", "Stats"]} /> */}
            {/* <Center w="100%" h="100%" bg="blue.1" opacity={0.1}> */}
            <Inventory />
            {/* </Center> */}
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
              <DndContext sensors={sensors}>
                <HoldableButton
                  w="100%"
                  mt="lg"
                  variant="light"
                  onPressed={activePressed}
                  onReleased={releasePressed}
                >
                  Shoot
                </HoldableButton>
              </DndContext>
            </Group>
            <Stack align="center">
              <ThemedJoystick
                size={180}
                stickSize={40}
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
