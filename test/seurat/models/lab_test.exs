defmodule Seurat.Models.LabTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Lab
  doctest Lab

  describe "conversions" do
    test "to Lab" do
      test_conversion(ColorMine, :lab, :lab, Lab)
    end

    test "to XYZ" do
      test_conversion(ColorMine, :xyz, :lab, Seurat.Models.Xyz)
    end
  end
end
