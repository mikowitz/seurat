defmodule Seurat.Models.XyzTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Xyz
  doctest Xyz

  describe "conversions" do
    test "to XYZ" do
      test_conversion(ColorMine, :xyz, :xyz, Xyz)
    end

    test "to RGB" do
      test_conversion(ColorMine, :rgb, :xyz, Seurat.Models.Rgb)
    end

    test "to Lab" do
      test_conversion(ColorMine, :lab, :xyz, Seurat.Models.Lab, 0.1)
    end

    test "to Luv" do
      test_conversion(HsluvDataset, :luv, :xyz, Seurat.Models.Luv)
    end

    test "to Yxy" do
      test_conversion(ColorMine, :yxy, :xyz, Seurat.Models.Yxy)
    end
  end
end
