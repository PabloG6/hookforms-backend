defmodule Haberdash.Inventory.Id do


  defmacro __using__(_) do
    quote do
      use Ecto.Type
      @prefix "inv"
      def type, do: :id
      def cast(<< _a1, _a2, _a3, _a4, _a5, _a6, _a7, _a8, ?-,
      _b1, _b2, _b3, _b4, ?-,
      _c1, _c2, _c3, _c4, ?-,
      _d1, _d2, _d3, _d4, ?-,
      _e1, _e2, _e3, _e4, _e5, _e6, _e7, _e8, _e9, _e10, _e11, _e12 >> = id), do: {:ok, @prefix <> "_" <> id}

      def dump(<< _a1, _a2, _a3, _a4, _a5, _a6, _a7, _a8, ?-,
      _b1, _b2, _b3, _b4, ?-,
      _c1, _c2, _c3, _c4, ?-,
      _d1, _d2, _d3, _d4, ?-,
      _e1, _e2, _e3, _e4, _e5, _e6, _e7, _e8, _e9, _e10, _e11, _e12 >> = term) when is_binary(term), do: {:ok, term}
      def dump(_), do: :error

      def load(<< _a1, _a2, _a3, _a4, _a5, _a6, _a7, _a8, ?-,
      _b1, _b2, _b3, _b4, ?-,
      _c1, _c2, _c3, _c4, ?-,
      _d1, _d2, _d3, _d4, ?-,
      _e1, _e2, _e3, _e4, _e5, _e6, _e7, _e8, _e9, _e10, _e11, _e12 >> = term) when is_binary(term), do: {:ok, term}

      def load(_), do: :error

      def generate(), do: @prefix <> "_" <> Ecto.UUID.generate |> String.replace("-", "")
      def autogenerate(), do: generate()


    end
  end



end
