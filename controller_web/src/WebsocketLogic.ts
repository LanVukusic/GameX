import useWebSocket from "react-use-websocket";

export const useGameSocket = () => {
  const socket = useWebSocket("ws://localhost:9080");

  return {
    readyState: socket.readyState,
  };
};
