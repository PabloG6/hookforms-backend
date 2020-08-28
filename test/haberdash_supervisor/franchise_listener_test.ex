defmodule Haberdash.FranchiseListenerTest do
  use ExUnit.Case, async: true
  use Haberdash.DataCase
  alias Haberdash.Supervisor
  alias Haberdash.{Business, Account}
  alias Haberdash
  @owner_attrs %{name: "Paul Lewis", email: "paullewis@email.com", password: "some random password", phone_number: "+19134583924"}


  setup do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, owner: owner}
  end

  @franchise_attrs %{name: "Quicky Chicky", description: "We sell fried chicken", phone_number: "+18764442344"}

  describe "franchise listener test" do
    test "create a new worker when a franchise is created", %{owner: owner} do
      assert {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))
      assert {:ok, pid} = Supervisor.Orders.start_child(franchise.id)
      IO.inspect Haberdash.Registry.Orders.whereis_name(franchise.id)
      assert {:ok, pid} = Haberdash.Registry.Orders.whereis_name(franchise.id)
      assert {:ok, franchise} = Business.delete_franchise(franchise)
      assert :ok = Supervisor.Orders.terminate_child(franchise.id)
      assert {:error, :undefined} = Haberdash.Registry.Orders.whereis_name(franchise.id)
    end
  end
end
