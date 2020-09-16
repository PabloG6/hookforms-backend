defmodule Haberdash.Exception.IncorrectFormat do
  defexception [:message, plug_status: 500]

  @impl true
  def exception(_) do
    %__MODULE__{message: "Incorrect format for this request. ", plug_status: 500}
  end
end
