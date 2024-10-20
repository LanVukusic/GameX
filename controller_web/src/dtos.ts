export interface ControllerMessage {
  t: string; // unique message type
}

export interface MoveMessage extends ControllerMessage {
  t: "move";
  x: number; // x joystick position
  y: number; // y joystick position
}

export interface LookMessage extends ControllerMessage {
  t: "look";
  x: number; // x joystick position
  y: number; // y joystick position
}

export interface LightMessage extends ControllerMessage {
  t: "light";
}
