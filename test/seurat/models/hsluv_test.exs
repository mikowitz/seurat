defmodule Seurat.Models.HsluvTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hsluv
  doctest Hsluv

  describe "conversions" do
    test "to HSLuv" do
      test_conversion(HsluvDataset, :hsluv, :hsluv, Hsluv)
    end

    test "to Lchuv" do
      test_conversion(HsluvDataset, :lchuv, :hsluv, Seurat.Models.Lchuv)
    end
  end
end
