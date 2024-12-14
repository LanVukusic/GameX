import { useDraggable } from "@dnd-kit/core";
import { useDebouncedCallback } from "@mantine/hooks";
import { PropsWithChildren, useEffect } from "react";

export interface IJoystickProps extends PropsWithChildren {
  radius: number;
  id: string;
  move: (x: number, y: number) => void;
  stop?: () => void;
  reportDebounce: number;
}

export function Draggable({
  id,
  children,
  radius,
  move,
  stop,
  reportDebounce,
}: IJoystickProps) {
  const { attributes, listeners, setNodeRef, transform, isDragging } =
    useDraggable({
      id,
    });

  const limitMovement = (x: number, y: number, radius: number) => {
    const distance = Math.sqrt(x * x + y * y);
    if (distance > radius) {
      const scale = radius / distance;
      return { x: x * scale, y: y * scale };
    }
    return { x, y };
  };

  const limitedTransform = transform
    ? limitMovement(transform.x, transform.y, radius)
    : { x: 0, y: 0 };

  const debouncedMove = useDebouncedCallback((x: number, y: number) => {
    move(x, y);
  }, reportDebounce);

  // handle move reporting
  useEffect(() => {
    debouncedMove(limitedTransform.x / radius, limitedTransform.y / radius);
  }, [transform]);

  // handle stopping
  useEffect(() => {
    if (!isDragging) {
      stop && stop();
    }
  }, [isDragging]);

  const style = {
    transform: `translate3d(${limitedTransform.x}px, ${limitedTransform.y}px, 0)`,
  };
  return (
    <div ref={setNodeRef} style={style} {...listeners} {...attributes}>
      {children}
    </div>
  );
}
