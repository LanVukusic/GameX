import useWebSocket from "react-use-websocket";
import { MSG } from "./dtos";

export const useGameSocket = () => {
  const socket = useWebSocket("ws://localhost:9999");

  const sendMsg = (msg: MSG) => {
    socket.sendJsonMessage(msg);
  };

  return {
    readyState: socket.readyState,
    sendMsg,
  };
};
