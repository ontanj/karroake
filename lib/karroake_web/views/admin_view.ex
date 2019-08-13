defmodule KarroakeWeb.AdminView do
  use KarroakeWeb, :view
  alias KarroakeWeb.RequestView

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
end
