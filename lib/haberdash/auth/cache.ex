defmodule Haberdash.Auth.Cache do
  use Nebulex.Cache,
    otp_app: :haberdash,
    adapter: Nebulex.Adapters.Local
end
