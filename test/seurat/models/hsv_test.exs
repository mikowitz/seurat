defmodule Seurat.Models.HsvTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hsv
  doctest Hsv

  test "to HSV" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsv: hsv} ->
      actual = Seurat.to(hsv, Hsv)

      assert_colors_equal(hsv, actual, color)
    end)
  end

  test "to RGB" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsv: hsv, rgb: expected} ->
      actual = Seurat.to(hsv, Seurat.Models.Rgb)

      assert_colors_equal(expected, actual, color)
    end)
  end

  test "to HSL" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsv: hsv, hsl: expected} ->
      actual = Seurat.to(hsv, Seurat.Models.Hsl)

      assert_colors_equal(expected, actual, color)
    end)
  end

  test "to HWB" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsv: hsv, hwb: expected} ->
      actual = Seurat.to(hsv, Seurat.Models.Hwb)

      assert_colors_equal(expected, actual, color)
    end)
  end
end
