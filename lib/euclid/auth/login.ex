defmodule Euclid.Auth.Login do
  use Euclid.Web, :model

  embedded_schema do
    field :email, :string
    field :password, :string
  end
end
