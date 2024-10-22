import { ActionIcon, ColorSwatch, Group, useMantineTheme } from "@mantine/core";

export const PlayerColorPicker = () => {
  const theme = useMantineTheme();

  return (
    <Group>
      {Object.keys(theme.colors).map((colorKey) => (
        <ActionIcon variant="subtle" size="lg">
          <ColorSwatch color={theme.colors[colorKey][6]} />
        </ActionIcon>
      ))}
    </Group>
  );
};
