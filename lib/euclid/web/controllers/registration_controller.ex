defmodule Euclid.Web.RegistrationController do
  use Euclid.Web, :controller

  alias Euclid.Auth
  alias Euclid.Auth.User

  def new(conn, _params, changeset \\ Auth.change_user(%User{})) do
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    case Auth.create_user(params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        new(conn, %{}, changeset)
    end
  end
end
