import {
  PointerEventHandlers,
  PointerSensorOptions,
  SensorProps,
  PointerSensorProps,
} from "@dnd-kit/core";
import type { TouchEvent } from "react";
import { AbstractPointerSensor } from "./pointer/AbstractPointerSensor";

const events: PointerEventHandlers = {
  cancel: { name: "touchcancel" },
  move: { name: "touchmove" },
  end: { name: "touchend" },
};

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface MultiTouchSensorOptions extends PointerSensorOptions {}

export type MultiTouchSensorProps = SensorProps<MultiTouchSensorOptions>;

export class MultiTouchSensor extends AbstractPointerSensor {
  constructor(props: PointerSensorProps) {
    super(props, events);
  }

  static activators = [
    {
      eventName: "onTouchStart" as const,
      handler: (
        { nativeEvent: event }: TouchEvent,
        { onActivation }: MultiTouchSensorOptions
      ) => {
        // const { touches } = event;

        // if (touches.length > 1) {
        //   return false;
        // }

        onActivation?.({ event });

        return true;
      },
    },
  ];

  static setup() {
    // Adding a non-capture and non-passive `touchmove` listener in order
    // to force `event.preventDefault()` calls to work in dynamically added
    // touchmove event handlers. This is required for iOS Safari.
    window.addEventListener(events.move.name, noop, {
      capture: false,
      passive: false,
    });

    return function teardown() {
      window.removeEventListener(events.move.name, noop);
    };

    // We create a new handler because the teardown function of another sensor
    // could remove our event listener if we use a referentially equal listener.
    function noop() {}
  }
}
