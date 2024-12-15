import {
  alpha,
  lighten,
  parseThemeColor,
  useMantineTheme,
} from "@mantine/core";
import { Joystick, IJoystickProps } from "react-joystick-component";

export const ThemedJoystick = ({ ...other }: IJoystickProps) => {
  const theme = useMantineTheme();
  const parsedColor = parseThemeColor({ color: theme.primaryColor, theme });
  return (
    <Joystick
      baseColor={alpha(lighten(parsedColor.value, 0.5), 0.2)}
      stickColor={alpha(lighten(parsedColor.value, 0.1), 0.8)}
      {...other}
    />
  );
};
