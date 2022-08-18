defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    random_int = Enum.random(1..10)
    {:ok, assign(socket, score: 0, message: "Make a guess:", uptime: time(), winner: random_int)}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      <br>
      It's <%= @uptime %>
      <br>
      Don't pick <%= @winner %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href='#' phx-click="guess" phx-value-number={n}> <%= n %> </a>
      <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    win = socket.assigns.winner
    g = Integer.parse(guess) |> elem(0)

    score = socket.assigns.score
    update_time = time()

    cond do
      win == g ->
        update_view(
          socket,
          "Your guess: #{guess}. YAY!!!",
          score + 10,
          update_time,
          win
        )

      true ->
        update_view(
          socket,
          "Your guess: #{guess}. WRONG!!!",
          score - 1,
          update_time,
          win
        )
    end
  end

  defp update_view(socket, msg, score, time, win) do
    {
      :noreply,
      assign(
        socket,
        message: msg,
        score: score,
        uptime: time,
        winner: win
      )
    }
  end
end
