import {
  ActionIcon,
  Alert,
  Group,
  LoadingOverlay,
  SimpleGrid,
  Stack,
  Title,
} from "@mantine/core";
import { PropsWithChildren } from "react";
import { DropableSlot } from "./DropableSlot";
import { IconChevronRight } from "@tabler/icons-react";
import { useStore } from "@nanostores/react";
import { $gameSocketStore } from "../../store/socketStore";

export interface IWeaponInventory extends PropsWithChildren {
  name: string;
}
export const WeaponInventory = ({ name }: IWeaponInventory) => {
  const socketStore = useStore($gameSocketStore);

  if (socketStore == null) {
    return (
      <LoadingOverlay
        visible={true}
        overlayProps={{
          blur: 15,
          opacity: 0.9,
        }}
      />
    );
  }

  return (
    <Alert>
      <Stack>
        <Group w="100%" justify="space-around" wrap="nowrap">
          <Title size="lg" textWrap="nowrap">
            {name}
          </Title>
          <Group gap="xl" w="100%" justify="end">
            <ActionIcon
              variant="subtle"
              size="lg"
              onClick={() => {
                socketStore.sendMsg({
                  t: "switch_w",
                });
              }}
            >
              <IconChevronRight size="2rem" />
            </ActionIcon>
          </Group>
        </Group>
        <SimpleGrid cols={6}>
          {[1, 2, 4, 4, 4, 4].map((_, i) => (
            <DropableSlot key={i} name={i.toString()} />
          ))}
        </SimpleGrid>
      </Stack>
    </Alert>
  );
};
