defmodule Haberdash.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo

  alias Haberdash.Account.Developers

  @doc """
  Returns the list of developer.

  ## Examples

      iex> list_developer()
      [%Developers{}, ...]

  """
  def list_developer do
    Repo.all(Developers)
  end

  @doc """
  Gets a single developers.

  Raises `Ecto.NoResultsError` if the Developers does not exist.

  ## Examples

      iex> get_developers!(123)
      %Developers{}

      iex> get_developers!(456)
      ** (Ecto.NoResultsError)

  """
  def get_developers!(id), do: Repo.get!(Developers, id)

  @doc """
  Creates a developers.

  ## Examples

      iex> create_developers(%{field: value})
      {:ok, %Developers{}}

      iex> create_developers(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_developers(attrs \\ %{}) do
    %Developers{}
    |> Developers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a developers.

  ## Examples

      iex> update_developers(developers, %{field: new_value})
      {:ok, %Developers{}}

      iex> update_developers(developers, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_developers(%Developers{} = developers, attrs) do
    developers
    |> Developers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a developers.

  ## Examples

      iex> delete_developers(developers)
      {:ok, %Developers{}}

      iex> delete_developers(developers)
      {:error, %Ecto.Changeset{}}

  """
  def delete_developers(%Developers{} = developers) do
    Repo.delete(developers)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking developers changes.

  ## Examples

      iex> change_developers(developers)
      %Ecto.Changeset{data: %Developers{}}

  """
  def change_developers(%Developers{} = developers, attrs \\ %{}) do
    Developers.changeset(developers, attrs)
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
  def delete_owner(%Owner{} = owner) do
    Repo.delete(owner)
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
end
