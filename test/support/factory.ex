defmodule Haberdash.Factory do
  alias Haberdash.{Account, Business, Inventory, Auth, Assoc}
  use ExMachina.Ecto, repo: Haberdash.Repo

  def owner_factory do
    %Account.Owner{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password_hash: Ecto.UUID.generate() |> Bcrypt.hash_pwd_salt,
      phone_number: "+#{Faker.Phone.EnUs.phone()}"
    }
  end

  def developer_factory do
    owner = insert(:owner)

    %Account.Developer{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password_hash: Ecto.UUID.generate() |> Bcrypt.hash_pwd_salt,
      owner_id: owner.id
    }
  end

  def franchise_factory(attrs \\ %{}) do
    owner = insert(:owner)

    franchise = %Business.Franchise{
      name: Faker.Company.name(),
      description: Faker.Company.catch_phrase(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      owner_id: owner.id
    }

    merge_attributes(franchise, attrs)
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

  def apikey_factory(attrs \\ %{}) do
    developer = insert(:developer)

    api_key = %Auth.ApiKey{
      developer_id: developer.id,
      api_key: UUID.uuid4(:hex)
    }

    merge_attributes(api_key, attrs)
  end

  def product_accessories_factory(attrs \\ %{}) do
    product = insert(:product)
    accessories = insert(:accessories)

    product_accessories = %Assoc.ProductAccessories{
      product_id: product.id,
      accessories_id: accessories.id
    }

    merge_attributes(product_accessories, attrs)
  end
end
