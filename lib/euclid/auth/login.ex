defmodule Euclid.Auth.Login do
  use Euclid.Web, :model

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Euclid.Auth

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @required_fields ~w(email password)a

  def changeset, do: changeset(%__MODULE__{}, %{})
  def changeset(params), do: changeset(%__MODULE__{}, params)
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def authenticate(%{valid?: true, changes: %{email: email, password: password}} = changeset) do
    user = Auth.get_by_email(email)

    case user do
      nil ->
        dummy_checkpw
        {:error, add_error(changeset, :base, "invalid email or password")}
      user ->
        IO.puts "checking"
        case checkpw(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, add_error(changeset, :base, "invalid email or password")}
        end
    end
  end
  def authenticate(changeset), do: {:error, changeset}
end
