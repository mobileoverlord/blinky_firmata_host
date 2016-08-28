defmodule BlinkyFirmataHost.Protocol do
  use GenServer
  use Firmata.Protocol.Mixin
  alias Firmata.Board

  def start_link(tty, opts \\ []) do
    GenServer.start_link(__MODULE__, [tty, opts], name: __MODULE__)
  end

  def init([tty, opts]) do
    IO.puts "Init"
    {:ok, board} = Board.start_link(tty, opts)
    {:ok, %{
      board: board
    }}
  end

  def handle_info({:firmata, {:pin_map, _pin_map}}, s) do
    IO.puts "Set Pin Map"
    Board.set_pin_mode(s.board, 13, @output)
    send(self, {:blink, 1})
    {:noreply, s}
  end

  def handle_info({:blink, state}, s) do
    IO.puts "Blink"
    Board.digital_write(s.board, 13, state)
    state = if state == 1, do: 0, else: 1
    Process.send_after(self, {:blink, state}, 1000)
    {:noreply, s}
  end

  def handle_info(_, s) do
    {:noreply, s}
  end
end
