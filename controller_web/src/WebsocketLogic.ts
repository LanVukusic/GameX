import useWebSocket from "react-use-websocket";
import { MSG } from "./dtos";

export const useGameSocket = () => {
  const socket = useWebSocket("ws://192.168.151.1:9080");

  const sendMsg = (msg: MSG) => {
    socket.sendJsonMessage(msg);
  };

  return {
    readyState: socket.readyState,
    sendMsg,
  };
};
