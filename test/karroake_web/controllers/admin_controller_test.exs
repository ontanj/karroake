defmodule KarroakeWeb.AdminControllerTest do
  use KarroakeWeb.ConnCase

  alias Karroake.KaraokeList

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
  def fixture(:set_song, request_id) do
    {:ok, set_song} = KaraokeList.create_set_song(request_id)
    set_song
  end
  def fixture(:request, id, song_id) do
    sid = Integer.to_string(id)
    {:ok, request} = KaraokeList.create_request(%{firstname1: "singer" <> sid, secondname1: "singer" <> sid}, song_id)
    request
  end

  describe "index" do
    test "show admin list with authentication", %{conn: conn} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> get(Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Nuvarande spellista"
    end

    test "show admin list without authentication", %{conn: conn} do
      conn = conn
      |> get(Routes.admin_path(conn, :index))
      assert text_response(conn, 401) =~ "401 Unauthorized"
    end
  end

  describe "make request a set song" do
    setup [:create_requests]
    test "approves when data is valid", %{conn: conn, requests: [request1 | _ ]} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> post(Routes.admin_path(conn, :create), request: request1.id)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)
      
      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "tillagd"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> post(Routes.admin_path(conn, :create), request: -1)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Något gick fel"
    end

    test "fails without authentication", %{conn: conn, requests: [request1 | _ ]} do
      conn = post(conn, Routes.admin_path(conn, :create), request: request1.id)
      assert text_response(conn, 401) =~ "401 Unauthorized"
    end

    test "request is moved to setlist", %{conn: conn, songs: [ %{artist: artist1} | [ %{artist: artist2} ]], requests: [request1 | [request2 | _]]} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> post(Routes.admin_path(conn, :create), request: request2.id)

      # check at admin page
      conn = get(conn, Routes.admin_path(conn, :index))
      resp = html_response(conn, 200)
      |> String.split("Förfrågningar")
      assert Enum.at(resp,0) =~ request2.firstname1
      assert Enum.at(resp,1) =~ request1.firstname1

      # check at playlist page
      conn = get(conn, Routes.request_path(conn, :index))
      resp = html_response(conn, 200)
      assert resp =~ artist2
      assert !String.contains?(resp, artist1)
    end
  end

  describe "update set song" do
    setup [:create_set_songs]

    test "played song is moved to history", %{conn: conn, songs: [%{artist: artist1} | [ %{artist: artist2}] ], set_songs: [set_song1 | _]} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> post(Routes.admin_path(conn, :played), setsong: set_song1.id)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.request_path(conn, :index))
      [future, history] = html_response(conn, 200)
      |> String.split("De senaste låtarna:")
      assert history =~ artist1
      assert future =~ artist2
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> post(Routes.admin_path(conn, :played), setsong: -1)
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Något gick fel"
    end
  end

  describe "delete requests" do
    setup [:create_requests]

    test "-1 deletes all", %{conn: conn, songs: [ %{artist: artist} | _ ]} do
      conn = conn
      |> using_basic_auth(@username, @password)
      |> delete(Routes.admin_path(conn, :delete), id: "all")
      assert redirected_to(conn) == Routes.admin_path(conn, :index)

      conn = get(conn, Routes.admin_path(conn, :index))
      resp = html_response(conn, 200) 
      assert resp =~ "tagits bort."
      assert !String.contains?(resp, artist)
    end
    # test "deletes chosen admin", %{conn: conn, admin: admin} do
    #   conn = delete(conn, Routes.admin_path(conn, :delete, admin))
    #   assert redirected_to(conn) == Routes.admin_path(conn, :index)
    #   assert_error_sent 404, fn ->
    #     get(conn, Routes.admin_path(conn, :show, admin))
    #   end
    # end
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

  defp create_set_songs(_) do
    {:ok, songs: songs, requests: requests = [ %{id: reqid1}, %{id: reqid2} ]} = create_requests(nil)
    set_songs = [fixture(:set_song, reqid1), fixture(:set_song, reqid2)]
    {:ok, songs: songs, requests: requests, set_songs: set_songs}
  end
end
