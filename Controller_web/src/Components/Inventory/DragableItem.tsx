import { useDraggable } from "@dnd-kit/core";
import { Alert, MantineStyleProp } from "@mantine/core";
import { PropsWithChildren } from "react";

export interface IDragableItem extends PropsWithChildren {
  name: string;
}

export const DraggableItem = ({ children, name }: IDragableItem) => {
  const { attributes, listeners, setNodeRef, transform } = useDraggable({
    id: name,
  });

  const style: MantineStyleProp = transform
    ? {
        touchAction: "manipulation",
        // transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`,
        opacity: 0.1,
      }
    : {};

  return (
    <Alert
      color="gray"
      p="0"
      ref={setNodeRef}
      {...listeners}
      {...attributes}
      style={{ ...style, aspectRatio: 1 }}
      variant={transform ? "filled" : "light"}
    >
      {children}
    </Alert>
  );
};
