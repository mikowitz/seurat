defmodule Seurat.ColorMine do
  @raw_data "test/support/data_color_mine.csv"
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
      color: row.color,
      rgb: Seurat.Models.Rgb.new(row.rgb_r, row.rgb_g, row.rgb_b),
      hsv: Seurat.Models.Hsv.new(row.hsv_h, row.hsv_s, row.hsv_v),
      hsl: Seurat.Models.Hsl.new(row.hsl_h, row.hsl_s, row.hsl_l),
      xyz: Seurat.Models.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z),
      hwb: Seurat.Models.Hwb.new(row.hwb_h, row.hwb_w, row.hwb_b),
      lab: Seurat.Models.Lab.new(row.lab_l_unscaled, row.lab_a_unscaled, row.lab_b_unscaled),
      yxy: Seurat.Models.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma)
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
