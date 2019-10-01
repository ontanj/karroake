defmodule KarroakeWeb.SongControllerTest do
    use KarroakeWeb.ConnCase
  
    alias Karroake.KaraokeList
    
    @create_attrs %{id: "3", artist: "Movits!", song: "Självantänd"}
    @invalid_attrs %{id: "3", artist: "Erik Lundin"}
    
    @username Application.get_env(:karroake, :auth)[:username]
    @password Application.get_env(:karroake, :auth)[:password]
  
    defp using_basic_auth(conn) do
      header_content = "Basic " <> Base.encode64("#{@username}:#{@password}")
      conn |> put_req_header("authorization", header_content)
    end
  
    def fixture(:song, id) do
      sid = Integer.to_string(id)
      {:ok, song} = KaraokeList.create_song(%{id: id, artist: "artist" <> sid, song: "låt" <> sid})
      song
    end
  
    describe "new song" do
      test "renders form when authenticated", %{conn: conn} do
        conn = using_basic_auth(conn)
        |> get(Routes.song_path(conn, :new))
        assert html_response(conn, 200) =~ "Lägg till ny låt"
      end
      test "don't show when not authenticated", %{conn: conn} do
        conn = get(conn, Routes.song_path(conn, :new))
        assert text_response(conn, 401) =~ "401 Unauthorized"
      end
    end
  
    describe "create song" do
      setup([:create_songs])
      test "adds song when data is valid", %{conn: conn} do
        conn = using_basic_auth(conn)
        |> post(Routes.song_path(conn, :create), song: @create_attrs)
        assert html_response(conn, 200) =~ "Låten är tillagd"
        assert html_response(conn, 200) =~ "Movits!"
      end
  
      test "renders errors when data is invalid", %{conn: conn} do
        conn = using_basic_auth(conn)
        |> post(Routes.song_path(conn, :create), song: @invalid_attrs)
        resp = html_response(conn, 200)
        |> String.split("Existerande låtar")
        assert Enum.at(resp, 0) =~ "Något gick snett"
        assert !String.contains?(Enum.at(resp, 1), "Erik Lundin")
  
        conn = post(conn, Routes.song_path(conn, :create), song: Enum.into(%{id: "1", song: "Euro"}, @invalid_attrs))
        resp = html_response(conn, 200)
        |> String.split("Existerande låtar")
        assert Enum.at(resp, 0) =~ "Något gick snett"
        assert !String.contains?(Enum.at(resp, 1), "Erik Lundin")
      end

      test "unavailable when unauthorized", %{conn: conn} do
        conn = post(conn, Routes.song_path(conn, :create), song: @create_attrs)
        assert text_response(conn, 401) =~ "401 Unauthorized"
      end
    end
  
    defp create_songs(_) do
      songs = [fixture(:song, 1), fixture(:song, 2)]
      {:ok, songs: songs}
    end

  end
  