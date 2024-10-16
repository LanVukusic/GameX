import { Box, parseThemeColor, useMantineTheme } from "@mantine/core";

export const ThemedShadow = () => {
  const theme = useMantineTheme();
  const parsedColor = parseThemeColor({ color: theme.primaryColor, theme });
  return (
    <Box
      mt="-20px"
      h="15px"
      w="100%"
      style={{
        boxShadow: `0px 1px 30px ${parsedColor.value}`,
      }}
    />
  );
};
