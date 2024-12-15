import {
  alpha,
  Box,
  ColorSwatch,
  lighten,
  parseThemeColor,
  useMantineTheme,
} from "@mantine/core";
import { Draggable, IJoystickProps } from "./Joystick";
import { useSensorsSettings } from "../DnD/UseSensors";
import { DndContext } from "@dnd-kit/core";

export const ThemedJoystick = (joyProps: IJoystickProps) => {
  const theme = useMantineTheme();
  const parsedColor = parseThemeColor({ color: theme.primaryColor, theme });
  const sensors = useSensorsSettings();
  return (
    <Box
      style={{
        touchAction: "manipulation",
        borderRadius: "100%",
        backgroundColor: alpha(lighten(parsedColor.value, 0.1), 0.1),
        padding: joyProps.radius + "px",
      }}
    >
      <DndContext sensors={sensors}>
        <Draggable {...joyProps}>
          <ColorSwatch
            color={alpha(lighten(parsedColor.value, 0.2), 0.8)}
            size="2rem"
          />
        </Draggable>
      </DndContext>
    </Box>
  );
};
