defmodule Euclid.Web.AuthErrorHandler do
  use Euclid.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new, next: conn.request_path))
  end
end
