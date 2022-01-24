defmodule Seurat.Models.RgbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Rgb
  doctest Rgb

  describe "conversions" do
    test "to RGB" do
      test_conversion(ColorMine, :rgb, :rgb, Rgb)
    end

    test "to HSV" do
      test_conversion(ColorMine, :hsv, :rgb, Seurat.Models.Hsv)
    end

    test "to HSL" do
      test_conversion(ColorMine, :hsl, :rgb, Seurat.Models.Hsl)
    end

    test "to HWB" do
      test_conversion(ColorMine, :hwb, :rgb, Seurat.Models.Hwb)
    end

    test "to XYZ" do
      test_conversion(ColorMine, :xyz, :rgb, Seurat.Models.Xyz)
    end
  end
end
