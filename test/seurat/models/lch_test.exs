defmodule Seurat.Models.LchTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Lch
  doctest Lch

  describe "conversions" do
    test "to Lch" do
      test_conversion(ColorMine, :lch, :lch, Lch)
    end

    test "to Lab" do
      test_conversion(ColorMine, :lab, :lch, Seurat.Models.Lab)
    end
  end
end
