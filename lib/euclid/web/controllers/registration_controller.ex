defmodule Euclid.Web.RegistrationController do
  use Euclid.Web, :controller

  alias Euclid.Auth.Registration

  def new(conn, _params, changeset \\ Registration.changeset()) do
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => params}) do
    changeset = Registration.changeset(params)

    case Registration.register_user(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        new(conn, %{}, %{changeset | action: :insert})
    end
  end
end
