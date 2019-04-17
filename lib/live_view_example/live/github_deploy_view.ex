defmodule LiveViewExampleWeb.GithubDeployView do
  use Phoenix.LiveView

  @deployment_steps %{
    "start"         => %{next_step: "deploy", text: "Ready!"},
    "deploy"        => %{next_step: "create-org", text: "Creating org"},
    "create-org"    => %{next_step: "create-repo", text: "Creating repo"},
    "create-repo"   => %{next_step: "push-contents", text: "Pushing contents"},
    "push-contents" => %{next_step: "done", text: "Done!"},
    "done"          => %{next_step: "", text: "Done!"}
  }

  @topic "deployments"

  def render(assigns) do
    LiveViewExampleWeb.PageView.render("github_deploy.html", assigns)
  end

  def mount(_session, socket) do
    LiveViewExampleWeb.Endpoint.subscribe(@topic)

    {:ok, assign(socket, build_state("start"))}
  end

  def handle_event(step, _value, socket) do
    step |> broadcast

    self() |> send(@deployment_steps[step][:next_step])

    {:noreply, assign(socket, build_state(step))}
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_info(status = "done", socket) do
    status |> broadcast

    {:noreply, assign(socket, build_state(status))}
  end

  def handle_info(step, socket) do
    LiveViewExample.GithubClient.run(step)

    step |> broadcast

    self() |> send(@deployment_steps[step][:next_step])

    {:noreply, assign(socket, build_state(step))}
  end

  defp broadcast(step) do
    state = build_state(step)
    LiveViewExampleWeb.Endpoint.broadcast_from(self(), @topic, step, state)
  end

  defp build_state(step) do
    %{text: @deployment_steps[step][:text],
      status: step
    }
  end
end
