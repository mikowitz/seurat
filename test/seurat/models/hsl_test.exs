defmodule Seurat.Models.HslTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hsl
  doctest Hsl

  test "to HSL" do
    test_conversion(ColorMine, :hsl, :hsl, Hsl)
  end

  test "to RGB" do
    test_conversion(ColorMine, :rgb, :hsl, Seurat.Models.Rgb)
  end

  test "to HSV" do
    test_conversion(ColorMine, :hsv, :hsl, Seurat.Models.Hsv)
  end
end
