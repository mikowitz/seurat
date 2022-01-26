defmodule Seurat.Models.LchuvTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Lchuv
  doctest Lchuv

  describe "conversions" do
    test "to Lchuv" do
      test_conversion(HsluvDataset, :lchuv, :lchuv, Lchuv)
    end

    test "to Luv" do
      test_conversion(HsluvDataset, :luv, :lchuv, Seurat.Models.Luv)
    end

    test "to Hsluv" do
      test_conversion(HsluvDataset, :hsluv, :lchuv, Seurat.Models.Hsluv)
    end
  end
end
