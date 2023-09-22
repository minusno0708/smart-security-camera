defmodule SecurityCameraServerWeb.SocketClient do
  use WebSockex

  def start_link(state) do
    WebSockex.start_link("ws://detect_api:8000/ws", __MODULE__, state)
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  def send_message(pid, message) do
    WebSockex.cast(pid, {:send, {:text, message}})
  end
end
