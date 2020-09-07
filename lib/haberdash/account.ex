defmodule Haberdash.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo
  use Nebulex.Caching
  alias Haberdash.Account.Developer
  alias Haberdash.{Account}

  @doc """
  Returns the list of developer.

  ## Examples

      iex> list_developer()
      [%Developer{}, ...]

  """
  def list_developer do
    Repo.all(Developer)
  end

  @doc """
  Gets a single developers.

  Raises `Ecto.NoResultsError` if the Developer does not exist.

  ## Examples

      iex> get_developers!(123)
      %Developer{}

      iex> get_developers!(456)
      ** (Ecto.NoResultsError)

  """
  def get_developer!(id), do: Repo.get!(Developer, id)
  def get_developer_by(opts), do: Repo.get_by(Developer, opts)

  @doc """
  Creates a developers.

  ## Examples

      iex> create_developers(%{field: value})
      {:ok, %Developer{}}

      iex> create_developers(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_developer(attrs \\ %{}) do
    %Developer{}
    |> Developer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a developers.

  ## Examples

      iex> update_developers(developers, %{field: new_value})
      {:ok, %Developer{}}

      iex> update_developers(developers, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_developer(%Developer{} = developers, attrs) do
    developers
    |> Developer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a developers.

  ## Examples

      iex> delete_developers(developers)
      {:ok, %Developer{}}

      iex> delete_developers(developers)
      {:error, %Ecto.Changeset{}}

  """
  def delete_developer(%Developer{} = developers) do
    Repo.delete(developers)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking developers changes.

  ## Examples

      iex> change_developers(developers)
      %Ecto.Changeset{data: %Developer{}}

  """
  def change_developer(%Developer{} = developers, attrs \\ %{}) do
    Developer.changeset(developers, attrs)
  end

  alias Haberdash.Account.Owner

  @doc """
  Returns the list of owner.

  ## Examples

      iex> list_owner()
      [%Owner{}, ...]

  """
  def list_owner do
    Repo.all(Owner)
  end

  @doc """
  Gets a single owner.

  Raises `Ecto.NoResultsError` if the Owner does not exist.

  ## Examples

      iex> get_owner!(123)
      %Owner{}

      iex> get_owner!(456)
      ** (Ecto.NoResultsError)

  """
  @decorate cacheable(cache: Cache, key: {Owner, id})
  def get_owner!(id), do: Repo.get!(Owner, id)

  @doc """
  Creates a owner.

  ## Examples

      iex> create_owner(%{field: value})
      {:ok, %Owner{}}

      iex> create_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_owner(attrs \\ %{}) do
    %Owner{}
    |> Owner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a owner.

  ## Examples

      iex> update_owner(owner, %{field: new_value})
      {:ok, %Owner{}}

      iex> update_owner(owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @decorate cache_put(cache: Account.Cache, key: {Owner, owner.id}, match: &match_update_owner/1)
  def update_owner(%Owner{} = owner, attrs) do
    owner
    |> Owner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a owner.

  ## Examples

      iex> delete_owner(owner)
      {:ok, %Owner{}}

      iex> delete_owner(owner)
      {:error, %Ecto.Changeset{}}

  """
  @decorate cache_evict(
              cache: Account.Cache,
              key: {Owner, owner.id},
              match: &match_delete_owner/1
            )
  def delete_owner(%Owner{} = owner) do
    Repo.delete(owner)
  end

  def authenticate(email, password) do
    with %Owner{} = owner <- Repo.get_by(Owner, email: email),
         {:ok, %Owner{}} = pass <- Bcrypt.check_pass(owner, password) do
      pass
    else
      nil ->
        {:error, :not_found}

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking owner changes.

  ## Examples

      iex> change_owner(owner)
      %Ecto.Changeset{data: %Owner{}}

  """
  def change_owner(%Owner{} = owner, attrs \\ %{}) do
    Owner.changeset(owner, attrs)
  end

  defp match_update_owner({:ok, owner}) do
    IO.inspect("update called")
    {true, owner}
  end

  defp match_update_owner({:error, %Ecto.Changeset{}}) do
    false
  end

  defp match_update_owner({:error, _}) do
    false
  end

  defp match_delete_owner({:ok, owner}) do
    IO.puts("delete called")
    {true, owner}
  end

  defp match_delete_owner({:error, _}) do
    false
  end

  alias Haberdash.Account.Customer

  @doc """
  Returns the list of customer.

  ## Examples

      iex> list_customer()
      [%Customer{}, ...]

  """
  def list_customer do
    Repo.all(Customer)
  end

  @doc """
  Gets a single customer.

  Raises `Ecto.NoResultsError` if the Customer does not exist.

  ## Examples

      iex> get_customer!(123)
      %Customer{}

      iex> get_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer!(id), do: Repo.get!(Customer, id)

  @doc """
  Creates a customer.

  ## Examples

      iex> create_customer(%{field: value})
      {:ok, %Customer{}}

      iex> create_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer.

  ## Examples

      iex> update_customer(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_customer(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer.

  ## Examples

      iex> delete_customer(customer)
      {:ok, %Customer{}}

      iex> delete_customer(customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer changes.

  ## Examples

      iex> change_customer(customer)
      %Ecto.Changeset{data: %Customer{}}

  """
  def change_customer(%Customer{} = customer, attrs \\ %{}) do
    Customer.changeset(customer, attrs)
  end
end
