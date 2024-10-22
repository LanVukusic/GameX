import { atom } from "nanostores";

export interface Player {
  color: string;
  name: string;
}

export const $player = atom<Player>({ color: "red", name: "" });

export function setName(name: string) {
  $player.set({
    name: name,
    color: $player.get().color,
  });
}

export function setColor(color: string) {
  $player.set({
    color: color,
    name: $player.get().name,
  });
}
