import { useSensor, MouseSensor, useSensors } from "@dnd-kit/core";
import { MultiTouchSensor } from "./TouchSensor";

export const useSensorsSettings = () => {
  const mouseSensor = useSensor(MouseSensor);
  const touchSensor = useSensor(MultiTouchSensor, {
    activationConstraint: {
      delay: 0,
      tolerance: 500,
      distance: 0,
    },
  });

  return useSensors(mouseSensor, touchSensor);
};
