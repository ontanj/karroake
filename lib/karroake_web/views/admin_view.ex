defmodule KarroakeWeb.AdminView do
  use KarroakeWeb, :view
  alias KarroakeWeb.RequestView

  require Logger

  def singer_name(a, b), do: RequestView.singer_name(a,b)
  def singer_name(a, b, c), do: RequestView.singer_name(a,b,c)

  def all_singers(request, separator) do
    name_string = for pos <- 1..3 do
      singer_name(request, pos)
    end
    |> Enum.filter(fn x -> !is_nil(x) end)
    |> List.foldl("", fn x, acc -> acc <> x <> separator end)
    String.slice(name_string, 0, String.length(name_string)- String.length(separator))
  end

  def get_time(time) do
    case DateTime.shift_zone(time, "Europe/Copenhagen") do
      {:ok, time} -> time |> DateTime.to_time |> Time.to_string |> String.slice(0..4)
      {:error, reason} -> reason |> inspect |> Logger.error; "Fel"
    end
  end
end
