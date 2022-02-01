defmodule Seurat.Models.RgbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.{Rgb, Xyz}
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

  describe "converting from different profiles to XYZ" do
    test "sRGB" do
      rgb = Rgb.new(0.5, 0, 1, :srgb)

      expected = Xyz.new(0.26872, 0.117696, 0.954442, :d65)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end

    test "Adobe RGB" do
      rgb = Rgb.new(0.5, 0, 1, :adobe)

      expected = Xyz.new(0.313704, 0.139994, 0.996992, :d65)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end

    test "ProPhoto RGB" do
      rgb = Rgb.new(0.5, 0, 1, :pro_photo)

      expected = Xyz.new(0.260425, 0.082804, 0.825210, :d50)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.05)
    end

    test "Wide Gamut RGB" do
      rgb = Rgb.new(0.5, 0, 1, :wide_gamut)

      expected = Xyz.new(0.303037, 0.073066, 0.773429, :d50)

      actual = Seurat.to(rgb, Xyz)

      assert_colors_equal(expected, actual, "test color", 0.01)
    end
  end
end
