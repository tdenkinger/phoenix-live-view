defmodule LiveViewExample do
  @moduledoc """
  LiveViewExample keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def view do
    quote do
      import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
    end
  end

  def router do
    quote do
      import Phoenix.LiveView.Router
    end
  end
end
