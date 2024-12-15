import { Flex, ScrollArea, SimpleGrid } from "@mantine/core";
import { DraggableItem } from "./DragableItem";
import { WeaponInventory } from "./WeaponInventory";
import { DndContext, DragOverlay } from "@dnd-kit/core";
import { useSensorsSettings } from "../DnD/UseSensors";

export const Inventory = () => {
  const sensors = useSensorsSettings();

  return (
    <DndContext sensors={sensors} autoScroll={false}>
      <Flex
        direction="column"
        h="100vh"
        py="md"
        gap="sm"
        style={{
          touchAction: "manipulation",
        }}
      >
        <WeaponInventory name="Jansa Cannon" />
        <DragOverlay>
          <DraggableItem key={0} name={"0"}>
            {/* <img src="/vite.svg" width="100%"></img> */}
          </DraggableItem>
        </DragOverlay>
        <ScrollArea
          scrollbars="y"
          type="always"
          scrollbarSize={26}
          style={{
            overflowX: "hidden",
            flex: 1,
          }}
        >
          <SimpleGrid cols={5} pr="xl">
            {[1, 23, 4, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 1, 2, 3, 4, 1, 3].map(
              (_, i) => (
                <DraggableItem key={i} name={i.toString()}>
                  <img
                    src={`/game_exports/bullet_${(i % 3) + 1}.png`}
                    width="100%"
                  ></img>
                </DraggableItem>
              )
            )}
          </SimpleGrid>
        </ScrollArea>
      </Flex>
    </DndContext>
  );
};
