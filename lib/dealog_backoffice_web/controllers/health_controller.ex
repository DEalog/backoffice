defmodule DealogBackofficeWeb.HealthController do
  use DealogBackofficeWeb, :controller

  def check(conn, _params) do
    conn
    |> put_status(200)
    |> json(%{status: "UP"})
  end
end
