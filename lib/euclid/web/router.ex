defmodule Euclid.Web.Router do
  use Euclid.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Euclid.Auth.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Euclid.Web do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index

    resources "/users", UserController, only: [:show]

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  scope "/auth", Euclid.Web do
    pipe_through [:browser, :with_session]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end
end
