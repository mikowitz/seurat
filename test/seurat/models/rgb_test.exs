defmodule Seurat.Models.RgbTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Rgb
  doctest Rgb

  describe "conversions" do
    test "to RGB" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, rgb: rgb} ->
        actual = Seurat.to(rgb, Rgb)

        assert_colors_equal(rgb, actual, color)
      end)
    end

    test "to HSV" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, rgb: rgb, hsv: expected} ->
        actual = Seurat.to(rgb, Seurat.Models.Hsv)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to HSL" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, rgb: rgb, hsl: expected} ->
        actual = Seurat.to(rgb, Seurat.Models.Hsl)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to HWB" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, rgb: rgb, hwb: expected} ->
        actual = Seurat.to(rgb, Seurat.Models.Hwb)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to XYZ" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, rgb: rgb, xyz: expected} ->
        actual = Seurat.to(rgb, Seurat.Models.Xyz)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
