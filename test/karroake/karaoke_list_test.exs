defmodule Karroake.KaraokeListTest do
  use Karroake.DataCase

  alias Karroake.KaraokeList

  describe "songs" do
    alias Karroake.KaraokeList.Song

    @valid_attrs %{artist: "some artist", song: "some song"}
    @update_attrs %{artist: "some updated artist", song: "some updated song"}
    @invalid_attrs %{artist: nil, song: nil}

    def song_fixture(attrs \\ %{}) do
      {:ok, song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> KaraokeList.create_song()

      song
    end

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert KaraokeList.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert KaraokeList.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      assert {:ok, %Song{} = song} = KaraokeList.create_song(@valid_attrs)
      assert song.artist == "some artist"
      assert song.song == "some song"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = KaraokeList.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = KaraokeList.update_song(song, @update_attrs)
      assert song.artist == "some updated artist"
      assert song.song == "some updated song"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = KaraokeList.update_song(song, @invalid_attrs)
      assert song == KaraokeList.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = KaraokeList.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> KaraokeList.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = KaraokeList.change_song(song)
    end
  end

  describe "requests" do
    alias Karroake.KaraokeList.Request

    @valid_attrs %{firstname1: "some firstname1", firstname2: "some firstname2", firstname3: "some firstname3", in_set: true, secondname1: "some secondname1", secondname2: "some secondname2", secondname3: "some secondname3"}
    @update_attrs %{firstname1: "some updated firstname1", firstname2: "some updated firstname2", firstname3: "some updated firstname3", in_set: false, secondname1: "some updated secondname1", secondname2: "some updated secondname2", secondname3: "some updated secondname3"}
    @invalid_attrs %{firstname1: nil, firstname2: nil, firstname3: nil, in_set: nil, secondname1: nil, secondname2: nil, secondname3: nil}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> KaraokeList.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert KaraokeList.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert KaraokeList.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = KaraokeList.create_request(@valid_attrs)
      assert request.firstname1 == "some firstname1"
      assert request.firstname2 == "some firstname2"
      assert request.firstname3 == "some firstname3"
      assert request.in_set == true
      assert request.secondname1 == "some secondname1"
      assert request.secondname2 == "some secondname2"
      assert request.secondname3 == "some secondname3"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = KaraokeList.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, %Request{} = request} = KaraokeList.update_request(request, @update_attrs)
      assert request.firstname1 == "some updated firstname1"
      assert request.firstname2 == "some updated firstname2"
      assert request.firstname3 == "some updated firstname3"
      assert request.in_set == false
      assert request.secondname1 == "some updated secondname1"
      assert request.secondname2 == "some updated secondname2"
      assert request.secondname3 == "some updated secondname3"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = KaraokeList.update_request(request, @invalid_attrs)
      assert request == KaraokeList.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = KaraokeList.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> KaraokeList.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = KaraokeList.change_request(request)
    end
  end
end
