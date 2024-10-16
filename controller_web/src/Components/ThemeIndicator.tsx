import { ColorSwatch, parseThemeColor, useMantineTheme } from "@mantine/core";

export const ThemeIndicator = () => {
  const theme = useMantineTheme();
  const parsedColor = parseThemeColor({ color: theme.primaryColor, theme });
  return <ColorSwatch color={parsedColor.value} size="2rem" />;
};
