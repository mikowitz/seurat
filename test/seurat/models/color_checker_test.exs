defmodule Seurat.ColorCheckerTest do
  use Seurat.ColorCase, async: true

  describe "converting ColorChecker data" do
    test "Lab to XYZ" do
      test_conversion(ColorChecker, :xyz, :lab, Seurat.Models.Xyz)
    end

    test "RGB to XYZ" do
      ColorChecker.data()
      |> Enum.map(fn %{color: color, rgb: rgb, xyz: expected} ->
        xyz_d65 = Seurat.to(rgb, Seurat.Models.Xyz)
        xyz_d50 = Seurat.Models.Xyz.adapt_into(xyz_d65, :d50)

        assert_colors_equal(expected, xyz_d50, color)
      end)
    end

    test "XYZ to Lab" do
      test_conversion(ColorChecker, :lab, :xyz, Seurat.Models.Lab)
    end

    test "XYZ to RGB" do
      test_conversion(ColorChecker, :rgb, :xyz, Seurat.Models.Rgb)
    end

    test "XYZ to Yxy" do
      test_conversion(ColorChecker, :yxy, :xyz, Seurat.Models.Yxy)
    end

    test "Yxy to Xyz" do
      test_conversion(ColorChecker, :xyz, :yxy, Seurat.Models.Xyz)
    end
  end

  describe "converting ColorChecker Babel average data" do
    test "Lab to XYZ" do
      test_conversion(ColorCheckerBabel, :xyz, :lab, Seurat.Models.Xyz)
    end

    test "RGB to XYZ" do
      ColorCheckerBabel.data()
      |> Enum.map(fn %{color: color, rgb: rgb, xyz: expected} ->
        xyz_d65 = Seurat.to(rgb, Seurat.Models.Xyz)
        xyz_d50 = Seurat.Models.Xyz.adapt_into(xyz_d65, :d50)

        assert_colors_equal(expected, xyz_d50, color)
      end)
    end

    test "XYZ to Lab" do
      test_conversion(ColorCheckerBabel, :lab, :xyz, Seurat.Models.Lab)
    end

    test "XYZ to RGB" do
      test_conversion(ColorCheckerBabel, :rgb, :xyz, Seurat.Models.Rgb)
    end

    test "XYZ to Yxy" do
      test_conversion(ColorCheckerBabel, :yxy, :xyz, Seurat.Models.Yxy)
    end

    test "Yxy to Xyz" do
      test_conversion(ColorCheckerBabel, :xyz, :yxy, Seurat.Models.Xyz)
    end
  end
end
