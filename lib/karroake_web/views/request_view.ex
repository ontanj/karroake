defmodule KarroakeWeb.RequestView do
  use KarroakeWeb, :view

  def singer_name(request, 1) do
    request.firstname1 <> " " <> request.secondname1
  end

  def singer_name(request, nbr) do
    case singer_name(request, nbr, :first) <> singer_name(request, nbr, :second) do
      "" -> nil
      any -> any
    end
  end
  
  def singer_name(%{firstname2: nil}, 2, :first) do
    ""
  end 
  def singer_name(%{firstname2: firstname}, 2, :first) do
    firstname <> " "
  end 
  def singer_name(%{secondname2: nil}, 2, :second) do
    ""
  end 
  def singer_name(%{secondname2: secondname}, 2, :second) do
    secondname
  end
  def singer_name(%{firstname3: nil}, 3, :first) do
    ""
  end 
  def singer_name(%{firstname3: firstname}, 3, :first) do
    firstname <> " "
  end 
  def singer_name(%{secondname3: nil}, 3, :second) do
    ""
  end 
  def singer_name(%{secondname3: secondname}, 3, :second) do
    secondname
  end 
end
