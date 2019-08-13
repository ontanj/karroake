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
end
