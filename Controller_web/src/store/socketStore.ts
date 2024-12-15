import { atom } from "nanostores";
import { GameSocketType } from "../WebsocketLogic";

export const $gameSocketStore = atom<GameSocketType | null>(null);
