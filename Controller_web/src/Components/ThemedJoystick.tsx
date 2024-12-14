import {
  alpha,
  Box,
  ColorSwatch,
  lighten,
  parseThemeColor,
  useMantineTheme,
} from "@mantine/core";
import { Draggable, IJoystickProps } from "../Controller/Joystick";

export const ThemedJoystick = (joyProps: IJoystickProps) => {
  const theme = useMantineTheme();
  const parsedColor = parseThemeColor({ color: theme.primaryColor, theme });
  return (
    <Box
      style={{
        borderRadius: "100%",
        backgroundColor: alpha(lighten(parsedColor.value, 0.1), 0.1),
        padding: joyProps.radius + "px",
      }}
    >
      <Draggable {...joyProps}>
        <ColorSwatch
          color={alpha(lighten(parsedColor.value, 0.2), 0.8)}
          size="2rem"
        />
      </Draggable>
    </Box>
  );
};
