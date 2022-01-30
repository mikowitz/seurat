defmodule Seurat.ColorDataCsvParser do
  defmacro __using__(file) do
    quote do
      @moduledoc false

      @raw_data "test/data/#{unquote(file)}.csv"
                |> File.read!()
                |> NimbleCSV.RFC4180.parse_string(skip_headers: false)

      def data do
        colors()
        |> Enum.map(fn row ->
          Enum.zip(headers(), Enum.map(row, &parse_float/1))
          |> Enum.into(%{})
          |> into_structs()
        end)
      end

      defp headers, do: List.first(@raw_data) |> Enum.map(&String.to_atom/1)
      defp colors, do: Enum.drop(@raw_data, 1)

      defp parse_float(s) do
        case Float.parse(s) do
          {f, _} -> f
          :error -> s
        end
      end
    end
  end
end
