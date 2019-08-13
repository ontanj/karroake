defmodule Karroake.Repo do
  use Ecto.Repo,
    otp_app: :karroake,
    adapter: Ecto.Adapters.Postgres
end
