defmodule Euclid.Auth.Registration do
  use Euclid.Web, :model
  alias Euclid.Auth.User
  alias Euclid.Repo

  embedded_schema do
    field :email, :string
    field :name, :string
    field :password, :string
  end

  @required_fields ~w(name email password)a

  def changeset, do: changeset(%__MODULE__{}, %{})
  def changeset(params), do: changeset(%__MODULE__{}, params)
  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def register_user(%{valid?: true} = changeset) do
    changeset
    |> apply_changes()
    |> to_user_changeset()
    |> create_user(changeset)
  end
  def register_user(changeset), do: {:error, changeset}

  defp create_user(user_changeset, registration_changeset) do
    case Repo.insert(user_changeset) do
      {:ok, user} ->
        {:ok, user}
      {:error, changeset} ->
        {:error, copy_errors(changeset, registration_changeset)}
    end
  end

  defp to_user_changeset(%__MODULE__{} = reg) do
    User.changeset(Map.from_struct(reg))
  end

  defp copy_errors(from, to) do
    Enum.reduce from.errors, to, fn {field, {msg, additional}}, acc ->
      Ecto.Changeset.add_error(acc, field, msg, additional: additional)
    end
  end
end
