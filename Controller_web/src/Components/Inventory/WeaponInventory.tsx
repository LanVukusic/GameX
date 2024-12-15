import {
  ActionIcon,
  Alert,
  Group,
  SimpleGrid,
  Stack,
  Title,
} from "@mantine/core";
import { PropsWithChildren } from "react";
import { DropableSlot } from "./DropableSlot";
import { IconChevronLeft, IconChevronRight } from "@tabler/icons-react";

export interface IWeaponInventory extends PropsWithChildren {
  name: string;
}
export const WeaponInventory = ({ name }: IWeaponInventory) => {
  return (
    <Alert>
      <Stack>
        <Group w="100%" justify="space-around" wrap="nowrap">
          <Title size="lg" textWrap="nowrap">
            {name}
          </Title>
          <Group gap="xl" w="100%" justify="end">
            <ActionIcon variant="subtle" size="lg">
              <IconChevronLeft size="2rem" />
            </ActionIcon>
            <ActionIcon variant="subtle" size="lg">
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
