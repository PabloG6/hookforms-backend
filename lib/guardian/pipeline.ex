defmodule Forms.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :forms,
  module: Forms.Guardian,
  error_handler: Forms.Auth.ErrorHandler
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession

  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true

end
