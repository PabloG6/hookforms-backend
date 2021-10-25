defmodule Forms.FolderTest do
  use Forms.DataCase

  alias Forms.Folder

  describe "form" do
    alias Forms.Folder.Form

    @valid_attrs %{description: "some description", questions: [], title: "some title"}
    @update_attrs %{description: "some updated description", questions: [], title: "some updated title"}
    @invalid_attrs %{description: nil, questions: nil, title: nil}

    def form_fixture(attrs \\ %{}) do
      {:ok, form} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Folder.create_form()

      form
    end

    test "list_form/0 returns all form" do
      form = form_fixture()
      assert Folder.list_form() == [form]
    end

    test "get_form!/1 returns the form with given id" do
      form = form_fixture()
      assert Folder.get_form!(form.id) == form
    end

    test "create_form/1 with valid data creates a form" do
      assert {:ok, %Form{} = form} = Folder.create_form(@valid_attrs)
      assert form.description == "some description"
      assert form.questions == []
      assert form.title == "some title"
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Folder.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      form = form_fixture()
      assert {:ok, %Form{} = form} = Folder.update_form(form, @update_attrs)
      assert form.description == "some updated description"
      assert form.questions == []
      assert form.title == "some updated title"
    end

    test "update_form/2 with invalid data returns error changeset" do
      form = form_fixture()
      assert {:error, %Ecto.Changeset{}} = Folder.update_form(form, @invalid_attrs)
      assert form == Folder.get_form!(form.id)
    end

    test "delete_form/1 deletes the form" do
      form = form_fixture()
      assert {:ok, %Form{}} = Folder.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Folder.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      form = form_fixture()
      assert %Ecto.Changeset{} = Folder.change_form(form)
    end
  end
end
