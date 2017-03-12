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
end
