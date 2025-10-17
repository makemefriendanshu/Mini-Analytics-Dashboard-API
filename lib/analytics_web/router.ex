defmodule AnalyticsWeb.Router do
  use AnalyticsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AnalyticsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AnalyticsWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  scope "/api", AnalyticsWeb do
    pipe_through :api

    post "/usage-summary", UsageSummaryController, :summary
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Analytics API",
        description: "API Documentation for Analytics Application",
        basePath: "/api"
      }
    }
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :analytics, swagger_file: "swagger.json"
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:analytics, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AnalyticsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
