defmodule Seurat.Models.HsvTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hsv
  doctest Hsv

  test "to HSV" do
    test_conversion(ColorMine, :hsv, :hsv, Hsv)
  end

  test "to RGB" do
    test_conversion(ColorMine, :rgb, :hsv, Seurat.Models.Rgb)
  end

  test "to HSL" do
    test_conversion(ColorMine, :hsl, :hsv, Seurat.Models.Hsl)
  end

  test "to HWB" do
    test_conversion(ColorMine, :hwb, :hsv, Seurat.Models.Hwb)
  end
end
