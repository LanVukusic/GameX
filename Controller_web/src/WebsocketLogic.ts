import useWebSocket, { ReadyState } from "react-use-websocket";
import { MSG } from "./dtos";
import { $gameSocketStore } from "./store/socketStore";

const hostname = window.location.hostname;

export type GameSocketType = {
  readyState: ReadyState;
  sendMsg: (msg: MSG) => void;
};

export const useGameSocket = (): GameSocketType => {
  const socket = useWebSocket(`ws://${hostname}:9999`);

  const sendMsg = (msg: MSG) => {
    socket.sendJsonMessage(msg);
  };

  $gameSocketStore.set({
    readyState: socket.readyState,
    sendMsg,
  });

  return {
    readyState: socket.readyState,
    sendMsg,
  };
};
