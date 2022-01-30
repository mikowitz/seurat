defmodule Seurat.ColorChecker do
  use Seurat.ColorDataCsvParser, "color_checker"

  defp into_structs(row) do
    %{
      color: row.color_name,
      xyz: Seurat.Models.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z, :d50),
      yxy: Seurat.Models.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma, :d50),
      lab: Seurat.Models.Lab.new(row.lab_l, row.lab_a, row.lab_b, :d50),
      rgb: Seurat.Models.Rgb.new(row.srgb_r / 255, row.srgb_g / 255, row.srgb_b / 255)
    }
  end
end
