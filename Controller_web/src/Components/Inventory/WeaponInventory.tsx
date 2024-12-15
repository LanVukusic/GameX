import { Alert, Group, SimpleGrid, Stack, Title } from "@mantine/core";
import { PropsWithChildren } from "react";
import { DropableSlot } from "./DropableSlot";

export interface IWeaponInventory extends PropsWithChildren {
  name: string;
}
export const WeaponInventory = ({ name }: IWeaponInventory) => {
  return (
    <Alert style={{ flex: 1 }}>
      <Stack>
        <Group w="100%" justify="space-around">
          <Title size="lg">{name}</Title>
        </Group>
        <SimpleGrid cols={5}>
          {[1, 2, 3, 4, 1, 1].map((val, i) => (
            <DropableSlot key={i} name={i.toString()} />
          ))}
        </SimpleGrid>
      </Stack>
    </Alert>
  );
};
