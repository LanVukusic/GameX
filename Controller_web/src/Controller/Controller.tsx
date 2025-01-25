import { DndContext } from "@dnd-kit/core";
import {
  ActionIcon,
  Button,
  Grid,
  Group,
  LoadingOverlay,
  Stack,
  useMantineTheme,
} from "@mantine/core";
import { useElementSize, useFullscreen } from "@mantine/hooks";
import { useStore } from "@nanostores/react";
import {
  IconBulb,
  IconChevronLeft,
  IconMaximize,
  IconMinimize,
  IconSettings,
} from "@tabler/icons-react";
import { useCallback, useEffect } from "react";
import { ReadyState } from "react-use-websocket";
import { useSensorsSettings } from "../Components/DnD/UseSensors";
import { HoldableButton } from "../Components/HoldableButton/HoldableButton";
import { ThemedJoystick } from "../Components/Joysticks/ThemedJoystick";
import { MessageTag } from "../sockets/dtos";
import { useGameSocket } from "../sockets/WebsocketLogic";
import { $player } from "../store/player";
import { LoaderContent } from "./Loader";
// const THROTTLE = 10; // ms for debounce

interface Props {
  setMenu: () => void;
}

export const Controller = ({ setMenu }: Props) => {
  const { toggle, fullscreen } = useFullscreen();
  const { sendMsg, readyState, sendTagged } = useGameSocket();
  const sensors = useSensorsSettings();
  // const readyState = ReadyState.OPEN;
  const { ref, width } = useElementSize();

  const player = useStore($player);
  const theme = useMantineTheme();
  const hex = theme.colors[player.color];

  const activePressed = useCallback(() => {
    // console.count("active");
    sendMsg({
      t: "shoot",
      state: "active",
    });
  }, [sendMsg]);

  const releasePressed = useCallback(() => {
    // console.count("released");
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
      <LoadingOverlay
        visible={readyState != ReadyState.OPEN}
        overlayProps={{
          blur: 15,
          opacity: 0.9,
        }}
        loaderProps={{ children: <LoaderContent setMenu={setMenu} /> }}
      />
      {/* <ThemedShadow /> */}

      <Grid
        p="xl"
        justify="flex-start"
        align="stretch"
        h="100%"
        styles={{
          inner: {
            height: "100%",
          },
        }}
      >
        <Grid.Col span={4} h="100%">
          <Stack h="100%" justify="space-between" align="center">
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
            <Stack align="center" w="100%" ref={ref}>
              <ThemedJoystick
                baseSize={width}
                onChange={(vec) => {
                  sendTagged(vec.x, vec.y, MessageTag.MOVE);
                }}
              />
            </Stack>
          </Stack>
        </Grid.Col>
        <Grid.Col span={4}>
          <Stack h="100%">
            {/* <SegmentedControl fullWidth data={["Inventory", "Map", "Stats"]} /> */}
            {/* <Center w="100%" h="100%" bg="blue.1" opacity={0.1}> */}
            {/* <Inventory /> */}
            {/* </Center> */}
          </Stack>
        </Grid.Col>
        <Grid.Col span={4}>
          <Stack h="100%" justify="space-between" align="center" py="md">
            <Group w="100%" px="xs">
              <DndContext sensors={sensors}>
                <HoldableButton
                  w="100%"
                  mt="lg"
                  p="md"
                  variant="light"
                  onPressed={() => {
                    sendMsg({
                      t: "reload",
                    });
                  }}
                  onReleased={() => {}}
                >
                  Reload
                </HoldableButton>
              </DndContext>
            </Group>
            <Stack align="center">
              <ThemedJoystick
                baseSize={width}
                onStop={releasePressed}
                onChange={(vec) => {
                  sendTagged(vec.x, vec.y, MessageTag.LOOK);
                  if (Math.abs(vec.x) > 0.8 || Math.abs(vec.y) > 0.8) {
                    activePressed();
                  }
                }}
              />
            </Stack>
          </Stack>
        </Grid.Col>
      </Grid>
    </Stack>
  );
};
