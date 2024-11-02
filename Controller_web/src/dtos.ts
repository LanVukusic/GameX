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

export interface ShootMessage extends ControllerMessage {
  t: "shoot";
  state: "active" | "release";
}

export interface ReloadMessage extends ControllerMessage {
  t: "reload";
}

export interface JoinMessage extends ControllerMessage {
  t: "join";
  name: string;
  color: string;
}

export type MSG =
  | MoveMessage
  | LookMessage
  | LightMessage
  | JoinMessage
  | ShootMessage
  | ReloadMessage;
