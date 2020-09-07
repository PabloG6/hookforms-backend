defmodule Haberdash.MapHelpers do
  defmacro __using__(_opts) do
    quote do
      # helper functions
      require Logger

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
          stringify_map(element, depth + 1)
        end
      end

      defp stringify_map(map, _), do: map

      defp safe_atom_to_string(key) when is_atom(key), do: Atom.to_string(key)
      defp safe_atom_to_string(key) when is_binary(key), do: key
      defp safe_atom_to_string(_), do: raise(ArgumentError, message: "key isn't a binary or atom")
    end
  end
end
