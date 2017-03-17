defmodule Glayu.CLI do
  
  def main(args) do
    args
    |> parse_args
    |> run 
  end

  defp parse_args([command | opts]) do
    module = get_module(command)
    options = apply module, :options, []
    aliases = apply module, :aliases, []
    parse = OptionParser.parse opts, strict: options, aliases: aliases
    case parse do
      {opts, args,[] } ->
        {:ok, command, %{opts: opts, args: args}}
      {opts, args, error} ->
        {:error, command, %{ opts: opts, args: args, error: error}}
    end
  end

  defp run({:ok, command, opts}) do
    apply get_module(command), :run, [opts]
  end

  defp run({:error, _, _}) do
    IO.puts "Unknown command"
  end

  defp get_module(command) do
    String.to_existing_atom("Elixir.Glayu.CLI." <> String.capitalize(command))
  end

end
  