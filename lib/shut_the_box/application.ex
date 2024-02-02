defmodule ShutTheBox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShutTheBoxWeb.Telemetry,
      ShutTheBox.Repo,
      {DNSCluster, query: Application.get_env(:shut_the_box, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ShutTheBox.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ShutTheBox.Finch},
      # Start a worker by calling: ShutTheBox.Worker.start_link(arg)
      # {ShutTheBox.Worker, arg},
      # Start to serve requests, typically the last entry
      ShutTheBoxWeb.Endpoint,
      ShutTheBox.Game.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShutTheBox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShutTheBoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
