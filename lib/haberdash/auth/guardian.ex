defmodule Haberdash.Auth.Guardian do
  use Guardian, otp_app: :haberdash
  require Logger
  alias Haberdash.{Account}

  def subject_for_token(%Account.Owner{id: id} = owner, _claims) do
    Logger.info("creating subject for token with owner id: #{id}")
    {:ok, "Owner:#{id}"}
  end

  def subject_for_token(%Account.Developer{id: id}, _claims) do
    Logger.info("subject_for_token being called for developer")
    {:ok, "Developer:#{id}"}
  end

  def resource_from_claims(%{"sub" => "Owner:" <> id}) do
    owner = Account.get_owner!(id)
    {:ok, owner}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
