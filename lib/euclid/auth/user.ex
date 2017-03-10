defmodule Euclid.Auth.User do
  use Euclid.Web, :model

  schema "auth_users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_admin, :boolean, default: false

    timestamps()
  end

  @required_fields ~w(name email password)a

  def changeset, do: changeset(%__MODULE__{}, %{})
  def changeset(params), do: changeset(%__MODULE__{}, params)
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{password: password},
      } ->
        put_change(
          changeset,
          :password_hash,
          Comeonin.Bcrypt.hashpwsalt(password)
        )
      _ ->
        changeset
    end
  end
end
