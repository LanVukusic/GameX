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

export interface JoinMessage extends ControllerMessage {
  t: "join";
  name: string;
  color: {
    r: number;
    g: number;
    b: number;
  };
}

export type MSG = MoveMessage | LookMessage | LightMessage;
