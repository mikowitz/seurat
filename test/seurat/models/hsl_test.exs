defmodule Seurat.Models.HslTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Hsl
  doctest Hsl

  test "to HSL" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsl: hsl} ->
      actual = Seurat.to(hsl, Hsl)

      assert_colors_equal(hsl, actual, color)
    end)
  end

  test "to RGB" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsl: hsl, rgb: expected} ->
      actual = Seurat.to(hsl, Seurat.Models.Rgb)

      assert_colors_equal(expected, actual, color)
    end)
  end

  test "to HSV" do
    ColorMine.data()
    |> Enum.map(fn %{color: color, hsl: hsl, hsv: expected} ->
      actual = Seurat.to(hsl, Seurat.Models.Hsv)

      assert_colors_equal(expected, actual, color)
    end)
  end
end
