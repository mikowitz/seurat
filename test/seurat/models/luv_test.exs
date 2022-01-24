defmodule Seurat.Models.LuvTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Luv
  doctest Luv

  describe "conversions" do
    test "to Luv" do
      test_conversion(HsluvDataset, :luv, :luv, Luv)
    end

    test "to XYZ" do
      test_conversion(HsluvDataset, :xyz, :luv, Seurat.Models.Xyz)
    end
  end
end
