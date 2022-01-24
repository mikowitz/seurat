defmodule Seurat.Models.YxyTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Yxy
  doctest Yxy

  describe "conversions" do
    test "to Yxy" do
      test_conversion(ColorMine, :yxy, :yxy, Yxy)
    end

    test "to XYZ" do
      test_conversion(ColorMine, :xyz, :yxy, Seurat.Models.Xyz)
    end
  end
end
