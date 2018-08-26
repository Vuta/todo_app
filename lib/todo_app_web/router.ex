defmodule TodoAppWeb.Router do
  use TodoAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug TodoApp.Guardian.AuthPipeline
  end

  scope "/", TodoAppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", TodoController, :index
    resources "/todos", TodoController do
      resources "/items", ItemController do
        put "/update_status", ItemController, :update_status, as: :update_status
      end
    end

    resources "/sessions", SessionController, only: [:new, :create]
    delete "/sign_out", SessionController, :delete

    resources "/registrations", RegistrationController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  scope "/api", TodoAppWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      post "/registrations", RegistrationController, :create
      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete
    end
  end

  scope "/api", TodoAppWeb, as: :api do
    pipe_through [:api, :jwt_authenticated]

    scope "/v1", Api.V1, as: :v1 do
      resources "/todos", TodoController, except: [:new, :edit] do
        resources "/items", ItemController, except: [:new, :edit, :index] do
          put "/update_status", ItemController, :update_status
        end
      end
    end
  end
end
