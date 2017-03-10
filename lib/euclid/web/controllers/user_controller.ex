defmodule Euclid.Web.UserController do
  use Euclid.Web, :controller

  alias Euclid.Auth.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Euclid.Web.AuthErrorHandler

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end
end
