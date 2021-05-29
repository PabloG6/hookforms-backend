require Logger

defimpl Plug.Exception, for: Haberdash.Exception.IncorrectFormat do
  @spec status(any) :: 500
  def status(_exception), do: 500

  def actions(_),
    do: [%{label: "Incorrect format for id", handler: {Logger, :info, ["Incorrect format"]}}]
end
