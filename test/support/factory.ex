defmodule Haberdash.DbFactory do
  alias Haberdash.{Account, Business, Inventory}
  use ExMachina.Ecto, repo: Haberdash.Repo
  def owner_factory do
    %Account.Owner{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password: Ecto.UUID.generate(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",


    }
  end

  def franchise_factory do
    owner = insert(:owner)
    %Business.Franchise{
      name: Faker.Company.name(),
      description: Faker.Company.catch_phrase(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      owner: owner.id

    }
  end

  def product_factory do
    franchise = insert(:franchise)
    %Inventory.Products{
      name: Faker.Food.dish(),
      description: Faker.Food.description(),
      price: :rand.uniform(10000),
      franchise_id: franchise.id
    }
  end

  def accessories_factory do
    franchise = insert(:franchise)
    %Inventory.Accessories{
      name: Faker.Food.dish(),
      description: Faker.Food.description(),
      price: :rand.uniform(10000),
      franchise_id: franchise.id
    }

  end


end
