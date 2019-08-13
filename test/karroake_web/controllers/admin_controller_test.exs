defmodule KarroakeWeb.AdminControllerTest do
  use KarroakeWeb.ConnCase

  alias Karroake.KaraokeList

  def fixture(:admin) do
    {:ok, song} = KaraokeList.create_song(%{id: 1, artist: "Movits!", song: "Självantänd"})
    {:ok, request} = KaraokeList.create_request(%{firstname1: "Karl", secondname1: "Dal"}, song.id)
    {:ok, _set_song} = KaraokeList.create_set_song(request.id)
  end

  describe "index" do
    test "show admin list", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 200) =~ "Nuvarande spellista"
    end
  end

  # describe "new admin" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.admin_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Admin"
  #   end
  # end

  # describe "create admin" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_path(conn, :create), admin: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.admin_path(conn, :show, id)

  #     conn = get(conn, Routes.admin_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Admin"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_path(conn, :create), admin: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Admin"
  #   end
  # end

  # describe "edit admin" do
  #   setup [:create_admin]

  #   test "renders form for editing chosen admin", %{conn: conn, admin: admin} do
  #     conn = get(conn, Routes.admin_path(conn, :edit, admin))
  #     assert html_response(conn, 200) =~ "Edit Admin"
  #   end
  # end

  # describe "update admin" do
  #   setup [:create_admin]

  #   test "redirects when data is valid", %{conn: conn, admin: admin} do
  #     conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @update_attrs)
  #     assert redirected_to(conn) == Routes.admin_path(conn, :show, admin)

  #     conn = get(conn, Routes.admin_path(conn, :show, admin))
  #     assert html_response(conn, 200)
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, admin: admin} do
  #     conn = put(conn, Routes.admin_path(conn, :update, admin), admin: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Admin"
  #   end
  # end

  # describe "delete admin" do
  #   setup [:create_admin]

  #   test "deletes chosen admin", %{conn: conn, admin: admin} do
  #     conn = delete(conn, Routes.admin_path(conn, :delete, admin))
  #     assert redirected_to(conn) == Routes.admin_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.admin_path(conn, :show, admin))
  #     end
  #   end
  # end

  # defp create_admin(_) do
  #   admin = fixture(:admin)
  #   {:ok, admin: admin}
  # end
end
