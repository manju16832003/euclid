defmodule Euclid.Auth do
  @moduledoc """
  The boundary for the Auth system.
  """

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.{Query, Changeset}, warn: false

  alias Euclid.Auth.{Login, User}
  alias Euclid.Repo

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Returns the User identitied by the email given.

  ## Examples

    iex> get_user_by_email(email)
    %User{}

    iex> get_user_by_email(email)
    nil
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  @doc """
  Authenticates a user using the given `attrs`.

  ## Examples

      iex> authenticate(%{"email" => "test@example.com", "password" => "s3kr!t"})
      {:ok, %User{}}

      iex> authenticate(%{"email" => "test@example.com", "password" => "wrong"})
      {:error, %Ecto.Changeset{source: %Login{}}}

  """
  def authenticate(attrs) do
    changeset = login_changeset(%Login{}, attrs)

    if changeset.valid? do
      %{changes: %{email: email, password: password}} = changeset
      user = get_user_by_email(email)

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
    else
      {:error, changeset}
    end
  end

  def change_login(%Login{} = login) do
    login_changeset(login, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :is_admin])
    |> validate_required([:name, :email, :password])
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

  defp login_changeset(%Login{} = login, attrs) do
    login
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
