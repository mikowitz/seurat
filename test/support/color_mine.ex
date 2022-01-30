defmodule Seurat.ColorMine do
  use Seurat.ColorDataCsvParser, "color_mine"

  defp into_structs(row) do
    %{
      color: row.color,
      rgb: Seurat.Models.Rgb.new(row.rgb_r, row.rgb_g, row.rgb_b),
      hsv: Seurat.Models.Hsv.new(row.hsv_h, row.hsv_s, row.hsv_v),
      hsl: Seurat.Models.Hsl.new(row.hsl_h, row.hsl_s, row.hsl_l),
      xyz: Seurat.Models.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z),
      hwb: Seurat.Models.Hwb.new(row.hwb_h, row.hwb_w, row.hwb_b),
      lab: Seurat.Models.Lab.new(row.lab_l_unscaled, row.lab_a_unscaled, row.lab_b_unscaled),
      yxy: Seurat.Models.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma),
      lch: Seurat.Models.Lch.new(row.lch_l_unscaled, row.lch_c_unscaled, row.lch_h_normalized)
    }
  end
end
