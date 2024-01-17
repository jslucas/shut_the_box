defmodule ShutTheBox.Repo do
  use Ecto.Repo,
    otp_app: :shut_the_box,
    adapter: Ecto.Adapters.Postgres
end
