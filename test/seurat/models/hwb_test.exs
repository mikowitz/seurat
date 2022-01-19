defmodule Seurat.Models.HwbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hwb
  doctest Hwb

  test "to HWB" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hwb: hwb} ->
      actual = Seurat.to(hwb, Hwb)

      assert_colors_equal(hwb, actual, color)
    end)
  end

  test "to HSV" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hwb: hwb, hsv: expected} ->
      actual = Seurat.to(hwb, Seurat.Models.Hsv)

      assert_colors_equal(expected, actual, color)
    end)
  end
end
