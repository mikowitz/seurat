defmodule Seurat.Models.HwbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hwb
  doctest Hwb

  test "to HWB" do
    test_conversion(ColorMine, :hwb, :hwb, Hwb)
  end

  test "to HSV" do
    test_conversion(ColorMine, :hsv, :hwb, Seurat.Models.Hsv)
  end
end
