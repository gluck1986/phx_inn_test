defmodule PhxWeb.Router do
  use PhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Phx.Users.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    post "/ip/lock", InnCheckController, :lock

    resources "/inn_checks", InnCheckController, only: [:index, :delete]
  end

  scope "/", PhxWeb do
    pipe_through [:browser, :auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    post "/logout", SessionController, :logout

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhxWeb do
  #   pipe_through :api
  # end
end
