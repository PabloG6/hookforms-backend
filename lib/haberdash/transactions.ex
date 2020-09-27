defmodule Haberdash.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Haberdash.Repo

  alias Haberdash.Transactions.Orders

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Orders{}, ...]

  """
  def list_orders do
    Repo.all(Orders)
  end

  @doc """
  Gets a single orders.

  Raises `Ecto.NoResultsError` if the Orders does not exist.

  ## Examples

      iex> get_orders!(123)
      %Orders{}

      iex> get_orders!(456)
      ** (Ecto.NoResultsError)

  """
  def get_orders!(id), do: Repo.get!(Orders, id)

  @doc """
  Creates a orders.

  ## Examples

      iex> create_orders(%{field: value})
      {:ok, %Orders{}}

      iex> create_orders(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orders(order, attrs \\ %{}) do
    order
    |> Orders.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a orders.

  ## Examples

      iex> update_orders(orders, %{field: new_value})
      {:ok, %Orders{}}

      iex> update_orders(orders, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orders(%Orders{} = orders, attrs) do
    orders
    |> Orders.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a orders.

  ## Examples

      iex> delete_orders(orders)
      {:ok, %Orders{}}

      iex> delete_orders(orders)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orders(%Orders{} = orders) do
    Repo.delete(orders)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orders changes.

  ## Examples

      iex> change_orders(orders)
      %Ecto.Changeset{data: %Orders{}}

  """
  def change_orders(%Orders{} = orders, attrs \\ %{}) do
    Orders.changeset(orders, attrs)
  end

  alias Haberdash.Transactions.Checkout

  @doc """
  Returns the list of checkout.

  ## Examples

      iex> list_checkout()
      [%Checkout{}, ...]

  """
  def list_checkout do
    Repo.all(Checkout)
  end

  @doc """
  Gets a single checkout.

  Raises `Ecto.NoResultsError` if the Checkout does not exist.

  ## Examples

      iex> get_checkout!(123)
      %Checkout{}

      iex> get_checkout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkout!(id), do: Repo.get!(Checkout, id)

  @doc """
  Creates a checkout.

  ## Examples

      iex> create_checkout(%{field: value})
      {:ok, %Checkout{}}

      iex> create_checkout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkout(attrs \\ %{}) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checkout.

  ## Examples

      iex> update_checkout(checkout, %{field: new_value})
      {:ok, %Checkout{}}

      iex> update_checkout(checkout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkout(%Checkout{} = checkout, attrs) do
    checkout
    |> Checkout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checkout.

  ## Examples

      iex> delete_checkout(checkout)
      {:ok, %Checkout{}}

      iex> delete_checkout(checkout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkout(%Checkout{} = checkout) do
    Repo.delete(checkout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkout changes.

  ## Examples

      iex> change_checkout(checkout)
      %Ecto.Changeset{data: %Checkout{}}

  """
  def change_checkout(%Checkout{} = checkout, attrs \\ %{}) do
    Checkout.changeset(checkout, attrs)
  end
end
