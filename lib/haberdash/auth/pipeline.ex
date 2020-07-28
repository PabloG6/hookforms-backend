defmodule Haberdash.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :haberdash,
    module: Haberdash.Auth.Guardian,
    error_handler: Haberdash.Auth.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.EnsureAuthenticated
end
