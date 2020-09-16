defmodule Haberdash.OrderWorkerTest do
  use ExUnit.Case
  use Haberdash.DataCase
  require Logger
  alias Haberdash.Transactions.{OrderWorker, OrderRegistry, OrderSupervisor}
  import Haberdash.Factory
  setup do
    franchise = insert(:franchise)
    product = insert(:product, %{franchise_id: franchise.id})
    accessories = insert(:accessories, %{franchise_id: franchise.id})
    _ = insert(:product_accessories,%{product_id: product.id, accessories_id: accessories.id})
    {:ok, product: product, accessories: accessories, franchise: franchise}
  end

  defp create_order(%{product: product, accessories: accessories, franchise: franchise}) do
    assert {:ok, pid} = OrderSupervisor.start_child(franchise.id)

    {:ok, pid} = OrderRegistry.whereis_name(franchise.id)
    {:ok, orders} = OrderWorker.create_order(pid, %{items: [%{id: "prod_" <> product.id, accessories: [%{id: "acc_" <> accessories.id}]}]})
    {:ok, orders: orders, pid: pid}
  end


  describe "checking reduce map function for map_helpers macro" do
    setup [:create_order]
    test "reduce a nested order total to a single price", %{orders: orders, product: product, accessories: accessories, pid: pid} do
      price = OrderWorker.reduce(orders, 0,
      fn key_val, acc ->
        case key_val do
          {"price", v} = tup ->
              v + acc

         tup ->
           acc
        end
      end)
      Logger.info("accessories.price: #{accessories.price}, product.price: #{product.price}, price: #{price}")
      assert price == accessories.price + product.price
      new_product = insert(:product)
      {:ok, new_orders} = OrderWorker.append_order(pid, orders["id"], %{items: [%{id: "prod_" <> new_product.id}]})
      new_price = OrderWorker.reduce(new_orders, 0,
      fn key_val, acc ->
        case key_val do
          {"price", v} ->
              v + acc

         _ ->
           acc
         end
      end)
      Logger.info("new_product.price: #{new_product.price} accessories.price: #{accessories.price}, product.price: #{product.price}, new_price: #{new_price}")

      assert new_price == accessories.price + new_product.price + product.price

    end
  end
end
