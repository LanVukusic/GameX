import { Button, Center, Stack, Title } from "@mantine/core";

interface Props {
  setMenu: () => void;
}
export const LoaderContent = ({ setMenu }: Props) => {
  return (
    <Center>
      <Stack>
        <Title>Connecting to the game...</Title>
        <Button variant="light" onClick={setMenu}>
          back to menu
        </Button>
      </Stack>
    </Center>
  );
};
