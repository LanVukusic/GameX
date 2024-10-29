import { ActionIcon, ColorSwatch, Group, useMantineTheme } from "@mantine/core";
import { setColor } from "../store/player";

export const PlayerColorPicker = () => {
  const theme = useMantineTheme();

  return (
    <Group>
      {Object.keys(theme.colors).map((colorKey) => (
        <ActionIcon
          variant={theme.primaryColor == colorKey ? "outline" : "subtle"}
          size="lg"
          onClick={() => {
            setColor(colorKey);
          }}
        >
          <ColorSwatch color={theme.colors[colorKey][6]} size="1.5rem" />
        </ActionIcon>
      ))}
    </Group>
  );
};
