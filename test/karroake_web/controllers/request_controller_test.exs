defmodule KarroakeWeb.RequestControllerTest do
  use KarroakeWeb.ConnCase

  alias Karroake.KaraokeList

  @create_attrs %{firstname1: "some firstname1", firstname2: "some firstname2", firstname3: "some firstname3", secondname1: "some secondname1", secondname2: "some secondname2", secondname3: "some secondname3", song_id: "1"}
  @invalid_attrs %{firstname1: nil, secondname1: nil}

  def fixture(:song) do
    {:ok, song} = KaraokeList.create_song(%{id: 1, artist: "Movits!", song: "Självantänd"})
    song
  end
  def fixture(:request) do
    {:ok, request} = KaraokeList.create_request(@create_attrs)
    request
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ "Här är spellistan just nu"
    end
  end

  describe "new request" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :new))
      assert html_response(conn, 200) =~ "Välj låt:"
    end
  end

  describe "create request" do
    setup([:create_song])
    test "shows request when data is valid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @create_attrs)
      assert html_response(conn, 200) =~ "Din önskning är inskickad!"
      assert html_response(conn, 200) =~ "Movits!"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs)
      assert html_response(conn, 200) =~ "Välj låt:"

      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs |> Enum.into(%{song_id: 1}))
      assert html_response(conn, 200) =~ "Välj låt:"

      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs |> Enum.into(%{firstname1: "Anna", secondname1: "Bengtsson"}))
      assert html_response(conn, 200) =~ "Välj låt:"
    end
  end

  defp create_song(_) do
    song = fixture(:song)
    {:ok, song: song}
  end
end
