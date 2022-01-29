defmodule Seurat.Inspect do
  defmacro __using__(fields) do
    quote do
      defimpl Inspect do
        import Inspect.Algebra

        def inspect(color, _opts) do
          concat([
            "#",
            struct_name(),
            "<",
            inspect_fields(color, unquote(fields)),
            inspect_white_point(color),
            ">"
          ])
        end

        defp inspect_white_point(%{white_point: wp}) do
          concat([
            " (",
            String.upcase(to_string(wp)),
            ")"
          ])
        end

        defp inspect_white_point(_), do: ""

        defp inspect_fields(color, fields) do
          Enum.map(fields, fn field ->
            Map.get(color, field)
            |> Float.round(4)
          end)
          |> Enum.join(", ")
        end

        defp struct_name do
          __MODULE__
          |> Module.split()
          |> Enum.drop_while(&(&1 != "Seurat"))
          |> Enum.join(".")
        end
      end
    end
  end
end
