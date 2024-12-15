import { useDroppable } from "@dnd-kit/core";
import { Alert, AspectRatio, Box } from "@mantine/core";
import { PropsWithChildren } from "react";

export interface IDropableSlot extends PropsWithChildren {
  name: string;
}
export const DropableSlot = ({ name, children }: IDropableSlot) => {
  const { isOver, setNodeRef } = useDroppable({
    id: name,
  });

  return (
    <Alert
      color="gray"
      ref={setNodeRef}
      variant={isOver ? "outline" : "light"}
      style={{
        aspectRatio: 1,
      }}
    >
      {/* <AspectRatio ratio={2 / 1} m="0px" p="0px"> */}
      {/* <div>1</div> */}
      {/* {children} */}
      {/* </AspectRatio> */}
    </Alert>
  );
};
