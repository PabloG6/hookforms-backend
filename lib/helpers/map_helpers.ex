defmodule Haberdash.MapHelpers do
  defmacro __using__(_opts) do
    quote do
      # helper functions
      require Logger

      #recursively iterates over an enumerable
      def reduce(enumerable, acc, func), do: reduce_func(enumerable, acc, func)

      defp reduce_func(struct, acc, _) when is_struct(struct), do: acc
      defp reduce_func(enumerable, acc, fun) when is_map(enumerable) do
        Enum.reduce(enumerable, acc, fn x, acc ->  reduce_func(x, acc, fun) end)
      end

      defp reduce_func(enumerable, acc, fun) when is_list(enumerable) do
        Enum.reduce(enumerable, acc, fn x, acc -> reduce_func(x, acc, fun) end)
      end

      defp reduce_func({k, v} = enumerable, acc, func) when is_tuple(enumerable), do: reduce_func(v, func.(enumerable, acc), func)
      defp reduce_func(_, acc, _), do: acc

      #converts atom maps to string with a depth of 2
      def stringify_map(map) when is_map(map), do: stringify_map(map, 0)

      defp stringify_map(%{__meta__: _} = map, depth) do
        Map.drop(map, map.__struct__.__schema__(:associations) ++ [:__meta__])
        |> Map.from_struct()
        |> stringify_map(depth)
      end

      defp stringify_map(%NaiveDateTime{} = map, _) do
        map
      end

      defp stringify_map(%{__struct__: _} = map, depth) do
        Map.from_struct(map) |> stringify_map(depth)
      end

      defp stringify_map(map, depth) when is_map(map) and depth < 2 do
        for {k, v} <- map, into: %{} do
          {safe_atom_to_string(k), stringify_map(v, depth + 1)}
        end
      end

      defp stringify_map(enum, depth) when is_list(enum) do
        for element <- enum do
          stringify_map(element, 0)
        end
      end

      defp stringify_map(map, _), do: map

      defp safe_atom_to_string(key) when is_atom(key), do: Atom.to_string(key)
      defp safe_atom_to_string(key) when is_binary(key), do: key
      defp safe_atom_to_string(_), do: raise(ArgumentError, message: "key isn't a binary or atom")

    end
  end
end
