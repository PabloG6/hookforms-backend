
defmodule Forms.Folder.Form do
  use Ecto.Schema
  import Ecto.Changeset
  alias Forms.Accounts
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "form" do
    field :description, :string
    field :questions, {:array, :map}
    field :url, :string
    field :title, :string
    belongs_to :owner, Accounts.Owner

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:title, :description, :questions, :owner_id, :url])

    |> validate_required([:title, :description, :questions, :owner_id, :url])
  end


end
