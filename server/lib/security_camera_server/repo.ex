defmodule SecurityCameraServer.Repo do
  use Ecto.Repo,
    otp_app: :security_camera_server,
    adapter: Ecto.Adapters.Postgres
end
