defmodule TodoApp.Guardian.AuthPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :todo_app, module: TodoApp.Guardian, error_handler: TodoApp.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
