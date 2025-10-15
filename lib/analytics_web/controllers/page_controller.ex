defmodule AnalyticsWeb.PageController do
  use AnalyticsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
