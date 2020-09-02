defmodule Haberdash.TransactionsTest do
  use Haberdash.DataCase

  alias Haberdash.{Transactions, Inventory, Business, Account, Assoc}

  @owner_attrs %{name: "Colonel Randers", email: "colonelranders@gmail.com", password: "heymanlol", phone_number: "+18763783891"}
  @franchise_attrs %{name: "Quicky Fried Chicken", description: "Quick and fast", email: "help@qfc.com", phone_number: "+18765198917"}
  @product_attrs %{name: "Ultra Deal", description: "Three pieces of chicken and some fries", price: 87500}
  @accessories_attrs %{name: "French Fries", description: "Fried potatoes with some salt", price: 99900}

  setup do
    :ok
  end



  def init(_) do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))
    {:ok, product} = Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, accessories} = Inventory.create_accessories(@accessories_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, product_accessories} = Assoc.create_product_accessories(%{product_id: product.id, accessories_id: accessories.id})
    {:ok, accessories: accessories, product: product, franchise: franchise, owner: owner}

  end

  describe "orders" do
    setup [:init]
    alias Haberdash.Transactions.Orders

    @valid_attrs %{customer_id: "some customer_id", drop_off_address: "some drop_off_address", drop_off_location: [], franchise_id: "some franchise_id", items: []}
    @update_attrs %{customer_id: "some updated customer_id", drop_off_address: "some updated drop_off_address", drop_off_location: [], franchise_id: "some updated franchise_id", items: []}
    @invalid_attrs %{customer_id: nil, drop_off_address: nil, drop_off_location: nil, franchise_id: nil, items: nil}



    def orders_fixture(attrs \\ %{}) do
      {:ok, orders} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_orders()

      orders
    end





    test "create_changeset/1 and update_changeset/1 with valid order changeset", %{product: product, franchise: franchise, accessories: accessories} do
      accessories_item = %{name: accessories.name, description: accessories.description, price: accessories.price, accessories_id: accessories.id}
      items = [%{product_id: product.id, name: product.name, description: product.description, price: product.price, accessories: [accessories_item]}]
      assert  %Ecto.Changeset{valid?: true, changes: _} = changeset =
              Transactions.Orders.create_changeset(%Transactions.Orders{}, %{franchise_id: franchise.id, items: items})

      {:ok, product_2} = Inventory.create_products(%{name: "Cookie Special", description: "An assortment of 24 cookies", price: 1999, franchise_id: franchise.id})
      {:ok, accessories_2} = Inventory.create_accessories(%{name: "Strawberry shake", description: "A strawberry shake", price: 999, franchise_id: franchise.id})
      accessories_item_2 = %{name: accessories_2.name, description: accessories_2.description, price: accessories_2.price, accessories_id: accessories_2.id}
      items = [%{product_id: product_2.id, name: product_2.name, description: product_2.description, price: product_2.price, accessories: [accessories_item_2]}]

      assert %Ecto.Changeset{valid?: true, changes: _updated_changes} = Transactions.Orders.update_changeset(changeset, %{franchise_id: franchise.id, items: items})
    end




    test "submit_orders/1 with valid data", %{} do

    end






  end
end
