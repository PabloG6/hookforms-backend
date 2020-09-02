defmodule Haberdash.Business do
  @moduledoc """
  The Business context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo
  alias Haberdash.Account.Cache
  use Nebulex.Caching


  alias Haberdash.Business.Franchise

  @doc """
  Returns the list of franchise.

  ## Examples

      iex> list_franchise()
      [%Franchise{}, ...]

  """
  def list_franchises do
    Repo.all(Franchise)
  end

  @doc """
  Gets a single franchise.

  Raises `Ecto.NoResultsError` if the Franchise does not exist.

  ## Examples

      iex> get_franchise!(123)
      %Franchise{}

      iex> get_franchise!(456)
      ** (Ecto.NoResultsError)

  """
  @decorate cacheable(cache: Cache, key: {Franchise, id})
  def get_franchise!(id), do: Repo.get!(Franchise, id)
  #TODO fix caching here sometime later.
  def get_franchise_by(opts) do
    with %Franchise{} = franchise <-  Repo.get_by(Franchise, opts) do
      {:ok, franchise}
    else
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a franchise.

  ## Examples

      iex> create_franchise(%{field: value})
      {:ok, %Franchise{}}

      iex> create_franchise(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_franchise(attrs \\ %{}) do
    %Franchise{}
    |> Franchise.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a franchise.

  ## Examples

      iex> update_franchise(franchise, %{field: new_value})
      {:ok, %Franchise{}}

      iex> update_franchise(franchise, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @decorate cache_put(cache: Cache, key: {Franchise, franchise.id}, match: &match_update_franchise/1)
  def update_franchise(%Franchise{} = franchise, attrs) do
    franchise
    |> Franchise.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a franchise.

  ## Examples

      iex> delete_franchise(franchise)
      {:ok, %Franchise{}}

      iex> delete_franchise(franchise)
      {:error, %Ecto.Changeset{}}

  """
  @decorate cache_evict(cache: Cache, key: {Franchise, franchise.id}, match: &match_delete_franchise/1)
  def delete_franchise(%Franchise{} = franchise) do
    Repo.delete(franchise)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking franchise changes.

  ## Examples

      iex> change_franchise(franchise)
      %Ecto.Changeset{data: %Franchise{}}

  """
  def change_franchise(%Franchise{} = franchise, attrs \\ %{}) do
    Franchise.changeset(franchise, attrs)
  end

  defp match_update_franchise({:ok, %Franchise{} = franchise}) do
    {true, franchise}
  end

  defp match_update_franchise({:error, _}), do: false

  defp match_delete_franchise({:ok, franchise}) do
    {true, franchise}
  end

  defp match_delete_franchise({:error, _}), do: false

end
