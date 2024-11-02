import useWebSocket from "react-use-websocket";
import { MSG } from "./dtos";

const hostname = "192.168.1.29";

export const useGameSocket = () => {
  const socket = useWebSocket(`ws://${hostname}:9999`);

  const sendMsg = (msg: MSG) => {
    socket.sendJsonMessage(msg);
  };

  return {
    readyState: socket.readyState,
    sendMsg,
  };
};
