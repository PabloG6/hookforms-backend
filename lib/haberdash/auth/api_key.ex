defmodule Haberdash.Auth.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset
  import UUID
  alias Haberdash.{Account}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  schema "api_key" do
    field :api_key, :string
    belongs_to :developer, Account.Developer

    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:developer_id])
    |> gen_key
    |> validate_required([:api_key, :developer_id])
  end

  defp gen_key(%Ecto.Changeset{valid?: true} = changeset) do
    put_change(changeset, :api_key, uuid4(:hex))
  end

  defp gen_key(changeset), do: changeset
end
