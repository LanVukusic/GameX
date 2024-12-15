import { useSensor, MouseSensor, TouchSensor, useSensors } from "@dnd-kit/core";

export const useSensorsSettings = () => {
  const mouseSensor = useSensor(MouseSensor);
  const touchSensor = useSensor(TouchSensor, {
    activationConstraint: {
      delay: 0,
      tolerance: 500,
      distance: 0,
    },
  });

  return useSensors(mouseSensor, touchSensor);
};
