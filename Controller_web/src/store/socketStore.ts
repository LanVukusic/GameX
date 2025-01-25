import { atom } from "nanostores";
import { GameSocketType } from "../sockets/WebsocketLogic";

export const $gameSocketStore = atom<GameSocketType | null>(null);
