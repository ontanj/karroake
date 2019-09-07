defmodule KarroakeWeb.RequestControllerTest do
  use KarroakeWeb.ConnCase

  alias Karroake.KaraokeList
  
  @create_attrs %{firstname1: "some firstname1", firstname2: "some firstname2", firstname3: "some firstname3", secondname1: "some secondname1", secondname2: "some secondname2", secondname3: "some secondname3", song_id: "1"}
  @invalid_attrs %{firstname1: nil, secondname1: nil}
  
  @username Application.get_env(:karroake, :auth)[:username]
  @password Application.get_env(:karroake, :auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  def fixture(:song, id) do
    sid = Integer.to_string(id)
    {:ok, song} = KaraokeList.create_song(%{id: id, artist: "artist" <> sid, song: "låt" <> sid})
    song
  end
  def fixture(:request, id, song_id) do
    sid = Integer.to_string(id)
    {:ok, request} = KaraokeList.create_request(%{firstname1: "singer" <> sid, secondname1: "singer" <> sid}, song_id)
    request
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ "Kommande låtar:"
    end
  end

  describe "new request" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :new))
      assert html_response(conn, 200) =~ "Välj låt:"
    end
  end

  describe "create request" do
    setup([:create_songs])
    test "shows request when data is valid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @create_attrs)
      assert html_response(conn, 200) =~ "Din önskning är inskickad!"
      assert html_response(conn, 200) =~ "artist1"
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

  describe "delete requests" do
    setup [:create_requests]

    test "passing all deletes all", %{conn: conn, songs: [ %{artist: artist} | _ ]} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> delete(Routes.request_path(conn, :delete), request: "all")
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      resp = html_response(conn, 200) 
      assert resp =~ "tagits bort."
      assert !String.contains?(resp, artist)
    end

    test "deletes chosen request", %{conn: conn, requests: [ %{id: id1, firstname1: firstname1} | [ %{firstname1: firstname2} | _ ] ] } do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> delete(Routes.request_path(conn, :delete), request: id1)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      resp = html_response(conn, 200)
      assert resp =~ "Förfrågningen har tagits bort."
      assert !String.contains?(resp, firstname1)
      assert resp =~ firstname2
    end
    
    test "fails without authentication", %{conn: conn, requests: [request1 | _ ]} do
      conn = delete(conn, Routes.request_path(conn, :delete), request: request1.id)
      assert text_response(conn, 401) =~ "401 Unauthorized"
    end
  end

  defp create_songs(_) do
    songs = [fixture(:song, 1), fixture(:song, 2)]
    {:ok, songs: songs}
  end

  defp create_requests(_) do
    {:ok, songs: songs = [ %{id: songid1}, %{id: songid2} ]} = create_songs(nil)
    requests = [fixture(:request, 1, songid1), fixture(:request, 2, songid2)]
    {:ok, songs: songs, requests: requests}
  end
end
