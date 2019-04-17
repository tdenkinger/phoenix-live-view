defmodule LiveViewExampleWeb.PageController do
  use LiveViewExampleWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, LiveViewExampleWeb.GithubDeployView, session: %{})
  end
end
