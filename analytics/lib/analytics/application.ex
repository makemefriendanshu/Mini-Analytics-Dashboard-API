defmodule Analytics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AnalyticsWeb.Telemetry,
      Analytics.Repo,
      {DNSCluster, query: Application.get_env(:analytics, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Analytics.PubSub},
      # Start a worker by calling: Analytics.Worker.start_link(arg)
      # {Analytics.Worker, arg},
      # Start to serve requests, typically the last entry
      AnalyticsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Analytics.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnalyticsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
