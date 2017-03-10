defmodule Euclid.Web.SessionController do
  use Euclid.Web, :controller

  alias Euclid.Auth.Login

  def new(conn, _params, changeset \\ Login.changeset()) do
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"login" => login_params} = params) do
    changeset = Login.changeset(login_params)

    case Login.authenticate(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Map.get(params, "next", page_path(conn, :index)))
      {:error, changeset} ->
        conn
        |> new(%{}, %{changeset | action: :insert})
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> redirect(to: page_path(conn, :index))
  end
end
