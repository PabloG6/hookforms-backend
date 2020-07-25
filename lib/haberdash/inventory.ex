defmodule Haberdash.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo

  alias Haberdash.Inventory.Products

  @doc """
  Returns the list of product.

  ## Examples

      iex> list_product()
      [%Products{}, ...]

  """
  def list_product do
    Repo.all(Products)
  end

  @doc """
  Gets a single products.

  Raises `Ecto.NoResultsError` if the Products does not exist.

  ## Examples

      iex> get_products!(123)
      %Products{}

      iex> get_products!(456)
      ** (Ecto.NoResultsError)

  """
  def get_products!(id), do: Repo.get!(Products, id)

  @doc """
  Creates a products.

  ## Examples

      iex> create_products(%{field: value})
      {:ok, %Products{}}

      iex> create_products(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_products(attrs \\ %{}) do
    %Products{}
    |> Products.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a products.

  ## Examples

      iex> update_products(products, %{field: new_value})
      {:ok, %Products{}}

      iex> update_products(products, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_products(%Products{} = products, attrs) do
    products
    |> Products.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a products.

  ## Examples

      iex> delete_products(products)
      {:ok, %Products{}}

      iex> delete_products(products)
      {:error, %Ecto.Changeset{}}

  """
  def delete_products(%Products{} = products) do
    Repo.delete(products)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking products changes.

  ## Examples

      iex> change_products(products)
      %Ecto.Changeset{data: %Products{}}

  """
  def change_products(%Products{} = products, attrs \\ %{}) do
    Products.changeset(products, attrs)
  end
end
