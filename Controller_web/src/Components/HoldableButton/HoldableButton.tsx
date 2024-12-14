import { useDraggable } from "@dnd-kit/core";
import { Button, ButtonProps } from "@mantine/core";
import { useEffect } from "react";

export interface IHoldableButtonProps extends ButtonProps {
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
    id: "ojla",
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
    <Button ref={setNodeRef} {...listeners} {...attributes} {...other}>
      {children}
    </Button>
  );
}
