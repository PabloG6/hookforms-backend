defmodule Haberdash.Messages do
  defmacro __using__(_) do
    quote do
      @unauthorized_key "This key either doesn't exist or is currently unauthorized to view the requested content. "
    end
  end
end
