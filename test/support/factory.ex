defmodule Haberdash.Factory do
  alias Haberdash.{Account, Business, Inventory, Auth, Assoc}
  use ExMachina.Ecto, repo: Haberdash.Repo

  def owner_factory(%{password: password}  = attrs) do
    owner = %Account.Owner{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      password_hash: password |> Bcrypt.hash_pwd_salt()
    }

    merge_attributes(owner, attrs)
  end


  def owner_factory(attrs) do
    owner = %Account.Owner{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      password_hash: Ecto.UUID.generate |> Bcrypt.hash_pwd_salt()
    }

    merge_attributes(owner, attrs)
  end
  def owner_factory do
    %Account.Owner{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      password_hash: Ecto.UUID.generate |> Bcrypt.hash_pwd_salt()
    }


  end



  def developer_factory(%{password: password} = attrs) do


    developer = %Account.Developer{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password_hash: password |> Bcrypt.hash_pwd_salt()

    }

    merge_attributes(developer, attrs)
  end

  def developer_factory(attrs) do
    owner = insert(:owner)

    developer = %Account.Developer{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password_hash: Ecto.UUID.generate |> Bcrypt.hash_pwd_salt(),
      owner_id: owner.id
    }

    merge_attributes(developer, attrs)
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

  def franchise_factory(attrs) do

    franchise = %Business.Franchise{
      name: Faker.Company.name(),
      description: Faker.Company.catch_phrase(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
    }

    merge_attributes(franchise, attrs)
  end

  def franchise_factory do
    owner = insert(:owner)

   %Business.Franchise{
      name: Faker.Company.name(),
      description: Faker.Company.catch_phrase(),
      phone_number: "+#{Faker.Phone.EnUs.phone()}",
      owner_id: owner.id
    }

  end

  def product_factory do
    franchise = insert(:franchise)

    %Inventory.Products{
      name: sequence(Faker.Food.dish()),
      description: Faker.Food.description(),
      price: :rand.uniform(10000),
      franchise_id: franchise.id
    }
  end



  def apikey_factory do
    developer = insert(:developer)

    %Auth.ApiKey{
      developer_id: developer.id,
      api_key: UUID.uuid4(:hex)
    }

  end

  def apikey_factory(attrs) do

    api_key = %Auth.ApiKey{
      api_key: UUID.uuid4(:hex)
    }

    merge_attributes(api_key, attrs)
  end


  def product_accessories_factory(attrs \\ %{}) do
    product = insert(:product)
    accessories = insert(:product)

    product_accessories = %Assoc.ProductAssoc{
      product_id: product.id,
      accessories_id: accessories.id
    }

    merge_attributes(product_accessories, attrs)
  end
end
