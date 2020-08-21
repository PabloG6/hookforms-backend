defmodule Haberdash.Assoc do
  @moduledoc """
  The Assoc context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo
  alias Haberdash.Assoc.ProductGroups

  @doc """
  Returns the list of product_groups.

  ## Examples

      iex> list_product_groups()
      [%ProductGroups{}, ...]

  """
  def list_product_groups do
    Repo.all(ProductGroups)
  end


  @doc """
  Gets a single product_groups.

  Raises `Ecto.NoResultsError` if the Product groups does not exist.

  ## Examples

      iex> get_product_groups!(123)
      %ProductGroups{}

      iex> get_product_groups!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_groups!(id), do: Repo.get!(ProductGroups, id)

  @doc """
  Gets a product by the opts

  Returns {:error, :not_found} if no results found.
  ## Example

    iex> get_product_groups_by([product_id: product_id, collection_id: collection_id])
    {:ok, product_collection}

    iex> get_product_group_by([])
    {:error, :not_found}
  """
  def get_product_groups_by(opts) do
    case Repo.get_by(ProductGroups, opts) do
      nil -> {:error, :not_found}
      %ProductGroups{} = product_group -> {:ok, product_group}
      _ -> {:error, :unknown}
    end
  end

  @doc """

  Get a product's grouping information
  ## Examples

    iex > get_product_group_info(id)
    [%ProductGroup{product: product, collection: collection}]

    iex> get_product_group_inf(nil)
      idk what error comes here lol
  """
  def list_product_group_info(product_id) do
    Repo.all(from pg in ProductGroups, where: pg.product_id == ^product_id) |> Repo.preload([:collection, :product])
  end

  @doc """
  Get a product's grouping information
  ## Examples
  iex > get_product_group_info(id)
  [%ProductGroup{product: product, collection: collection}]
  """

  def list_collection_product_info(collection_id) do
    Repo.all(from pg in ProductGroups, where: pg.collection_id == ^collection_id) |> Repo.preload([:collection, :product])
  end
  @doc """
  Creates a product_groups.

  ## Examples

      iex> create_product_groups(%{field: value})
      {:ok, %ProductGroups{}}

      iex> create_product_groups(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_groups(attrs \\ %{}) do
    %ProductGroups{}
    |> ProductGroups.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_groups.

  ## Examples

      iex> update_product_groups(product_groups, %{field: new_value})
      {:ok, %ProductGroups{}}

      iex> update_product_groups(product_groups, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_groups(%ProductGroups{} = product_groups, attrs) do
    product_groups
    |> ProductGroups.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_groups.

  ## Examples

      iex> delete_product_groups(product_groups)
      {:ok, %ProductGroups{}}

      iex> delete_product_groups(product_groups)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_groups(%ProductGroups{} = product_groups) do
    Repo.delete(product_groups)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_groups changes.

  ## Examples

      iex> change_product_groups(product_groups)
      %Ecto.Changeset{data: %ProductGroups{}}

  """
  def change_product_groups(%ProductGroups{} = product_groups, attrs \\ %{}) do
    ProductGroups.changeset(product_groups, attrs)
  end

  alias Haberdash.Assoc.ProductAccessories

  @doc """
  Returns the list of product_accessories.

  ## Examples

      iex> list_product_accessories()
      [%ProductAccessories{}, ...]

  """
  def list_product_accessories do
    Repo.all(ProductAccessories)
  end

  @doc """
  Gets a single product_accessories.

  Raises `Ecto.NoResultsError` if the Product accessories does not exist.

  ## Examples

      iex> get_product_accessories!(123)
      %ProductAccessories{}

      iex> get_product_accessories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_accessories!(id), do: Repo.get!(ProductAccessories, id)

  @doc """
  Creates a product_accessories.

  ## Examples

      iex> create_product_accessories(%{field: value})
      {:ok, %ProductAccessories{}}

      iex> create_product_accessories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_accessories(attrs \\ %{}) do
    %ProductAccessories{}
    |> ProductAccessories.changeset(attrs)
    |> Repo.insert()
  end

  def get_product_accessories_by(opts) do
    case Repo.get_by(ProductAccessories, opts) do
      nil ->
        {:error, :not_found}
      product_accessories ->
        {:ok, product_accessories}
    end
  end


  @doc """
  Updates a product_accessories.

  ## Examples

      iex> update_product_accessories(product_accessories, %{field: new_value})
      {:ok, %ProductAccessories{}}

      iex> update_product_accessories(product_accessories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_accessories(%ProductAccessories{} = product_accessories, attrs) do
    product_accessories
    |> ProductAccessories.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_accessories.

  ## Examples

      iex> delete_product_accessories(product_accessories)
      {:ok, %ProductAccessories{}}

      iex> delete_product_accessories(product_accessories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_accessories(%ProductAccessories{} = product_accessories) do
    Repo.delete(product_accessories)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_accessories changes.

  ## Examples

      iex> change_product_accessories(product_accessories)
      %Ecto.Changeset{data: %ProductAccessories{}}

  """
  def change_product_accessories(%ProductAccessories{} = product_accessories, attrs \\ %{}) do
    ProductAccessories.changeset(product_accessories, attrs)
  end
end
