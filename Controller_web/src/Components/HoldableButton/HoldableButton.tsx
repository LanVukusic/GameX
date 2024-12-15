import { useDraggable } from "@dnd-kit/core";
import { Alert, AlertProps, Group } from "@mantine/core";
import { useEffect } from "react";

export interface IHoldableButtonProps extends AlertProps {
  onPressed: () => void;
  onReleased: () => void;
}

export function HoldableButton({
  onPressed,
  onReleased,
  children,
  ...other
}: IHoldableButtonProps) {
  const { attributes, listeners, setNodeRef, isDragging } = useDraggable({
    id: "button",
  });

  // handle stopping
  useEffect(() => {
    if (isDragging) {
      onPressed();
    } else {
      onReleased();
    }
  }, [isDragging]);

  return (
    <Alert
      ref={setNodeRef}
      {...listeners}
      {...attributes}
      {...other}
      variant={isDragging ? "filled" : "light"}
      style={{
        touchAction: "manipulation",
      }}
    >
      <Group justify="center">{children}</Group>
    </Alert>
  );
}
