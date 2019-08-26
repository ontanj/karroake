defmodule KarroakeWeb.AdminView do
  use KarroakeWeb, :view
  alias KarroakeWeb.RequestView

  require Logger

  def singer_name(a, b), do: RequestView.singer_name(a,b)
  def singer_name(a, b, c), do: RequestView.singer_name(a,b,c)

  def all_singers(request, separator), do: RequestView.all_singers(request, separator)

  def get_time(time) do
    case DateTime.shift_zone(time, "Europe/Copenhagen") do
      {:ok, time} -> time |> DateTime.to_time |> Time.to_string |> String.slice(0..4)
      {:error, reason} -> reason |> inspect |> Logger.error; "Fel"
    end
  end
end
