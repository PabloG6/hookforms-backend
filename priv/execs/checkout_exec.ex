alias Haberdash.{Business, Auth, Repo, Account}
alias Haberdash.Transactions.{OrderWorker, OrderRegistry, OrderSupervisor}
api_key = Repo.get_by(Auth.ApiKey, [api_key: "3ba5f252cb4e49da88e649cb5bdfeb93"])
developer = Repo.get_by(Account.Developer, [id: api_key.developer_id])
owner = Repo.get_by(Account.Owner, [id: developer.owner_id])

franchise = Repo.get_by(Business.Franchise, [owner_id: owner.id])
IO.inspect franchise
_ = OrderSupervisor.start_child(franchise.id)
franchise = franchise |> Repo.preload([:inventory])
product = franchise.inventory |> List.first
IO.inspect product
{:ok, pid} = OrderRegistry.whereis_name(franchise.id)
IO.inspect pid
{:ok, order} = OrderWorker.create_order(pid, %{items: [%{id: "prod_" <> product.id}]})
IO.inspect order
