defmodule Seurat.ColorCheckerBabel do
  @moduledoc false

  @raw_data "test/support/babel.csv"
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

  defp into_structs(row) do
    %{
      color: row.color_name,
      xyz: Seurat.Models.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z, :d50),
      yxy: Seurat.Models.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma, :d50),
      lab: Seurat.Models.Lab.new(row.lab_l, row.lab_a, row.lab_b, :d50),
      rgb: Seurat.Models.Rgb.new(row.srgb_r / 255, row.srgb_g / 255, row.srgb_b / 255)
    }
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
