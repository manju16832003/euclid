defmodule Euclid.Repo.Migrations.CreateEuclid.Auth.User do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :is_admin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:auth_users, [:email])

  end
end
