defmodule Seurat.ColorChecker do
  use Seurat.ColorDataCsvParser, "color_checker"

  defp into_structs(row) do
    %{
      color: row.color_name,
      xyz: Seurat.Models.Xyz.new(row.xyz_x, row.xyz_y, row.xyz_z, :d50),
      yxy: Seurat.Models.Yxy.new(row.yxy_x, row.yxy_y, row.yxy_luma, :d50),
      lab: Seurat.Models.Lab.new(row.lab_l, row.lab_a, row.lab_b, :d50),
      srgb: rgb_with_profile(row.srgb_r, row.srgb_g, row.srgb_b, :srgb),
      adobe_rgb: rgb_with_profile(row.adobe_r, row.adobe_g, row.adobe_b, :adobe),
      apple_rgb: rgb_with_profile(row.apple_rgb_r, row.apple_rgb_g, row.apple_rgb_b, :apple),
      pro_photo_rgb: rgb_with_profile(row.prophoto_r, row.prophoto_g, row.prophoto_b, :pro_photo)
    }
  end

  defp rgb_with_profile(r, g, b, profile) do
    Seurat.Models.Rgb.new(
      r / 255,
      g / 255,
      b / 255,
      profile
    )
  end
end
