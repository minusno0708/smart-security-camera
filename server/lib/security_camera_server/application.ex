defmodule SecurityCameraServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SecurityCameraServerWeb.Telemetry,
      # Start the Ecto repository
      SecurityCameraServer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SecurityCameraServer.PubSub},
      # Start Finch
      {Finch, name: SecurityCameraServer.Finch},
      # Start the Endpoint (http/https)
      SecurityCameraServerWeb.Endpoint
      # Start a worker by calling: SecurityCameraServer.Worker.start_link(arg)
      # {SecurityCameraServer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SecurityCameraServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SecurityCameraServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
