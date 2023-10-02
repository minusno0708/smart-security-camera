defmodule SecurityCameraServerWeb.CameraChannel do
  use SecurityCameraServerWeb, :channel

  alias SecurityCameraServerWeb.SocketClient

  @impl true
  def join("camera:"  <> room_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket |> assign(:room_id, room_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    IO.puts("ping")
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (camera:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("connect_api", payload, socket) do
    case SocketClient.start_link("") do
      {:ok, pid} ->
        IO.puts("pid:")
        IO.inspect(pid)
        payload = put_in(payload["body"]["message"], "Connection success")
        {:reply, {:ok, payload}, socket}
      {:error, reason} ->
        IO.puts("error:")
        IO.inspect(reason)
        payload = put_in(payload["body"]["message"], "Connection error")
        {:reply, {:ok, payload}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
