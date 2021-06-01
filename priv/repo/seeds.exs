# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Haberdash.Repo.insert!(%Haberdash.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Haberdash.Factory
%Haberdash.Account.Owner{} = owner = insert(:owner, %{name: "Yakihiru Soma", email: "tetsu@email.com", password: "password"})
%Haberdash.Account.Developer{} = developer = insert(:developer, %{name: "Yukihiro Matsumoto", email: "yukihiromatsumoto@rubydev.com", owner_id: owner.id})
%Haberdash.Business.Franchise{} = franchise = insert(:franchise, %{name: "Soma Japanese Luxury Cuisine", owner_id: owner.id})
insert
