import useWebSocket from "react-use-websocket";
import { MessageTag, MSG } from "./dtos";
import { $gameSocketStore } from "../store/socketStore";
import { joinBuffers } from "./utils";

const hostname = window.location.hostname;

export const useGameSocket = () => {
  const socket = useWebSocket(`ws://${hostname}:9999`);

  const sendTagged = (x: number, y: number, tag: MessageTag) => {
    const tagAr = new Uint8Array([0, tag]);
    const msgAr = new Float32Array([x, y]);
    socket.sendMessage(joinBuffers(tagAr.buffer, msgAr.buffer));
  };

  const sendMsg = (msg: MSG) => {
    const tagAr = new Uint8Array([1]);
    const jsonString = JSON.stringify(msg);
    // Step 2: Encode the string to UTF-8
    const encoder = new TextEncoder();
    const uint8Array = encoder.encode(jsonString);
    // Step 3: Extract the ArrayBuffer
    const arrayBuffer = uint8Array.buffer;
    socket.sendMessage(joinBuffers(tagAr.buffer, arrayBuffer));
  };

  $gameSocketStore.set({
    readyState: socket.readyState,
    sendMsg,
  });

  return {
    readyState: socket.readyState,
    sendMsg,
    sendTagged,
  };
};
