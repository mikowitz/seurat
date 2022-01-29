defmodule Seurat.Conversions.RgbXyzMatrixTest do
  use ExUnit.Case, async: true

  alias Seurat.Conversions.RgbXyzMatrix

  describe "sRGB/D65" do
    test "generating matrix for sRGB to D65" do
      expected = [
        [0.4124564, 0.3575761, 0.1804375],
        [0.2126729, 0.7151522, 0.0721750],
        [0.0193339, 0.1191920, 0.9503041]
      ]

      actual = RgbXyzMatrix.matrix(:srgb, :d65)

      for y <- 0..2, x <- 0..2 do
        assert_in_delta Enum.at(Enum.at(expected, y), x), Enum.at(Enum.at(actual, y), x), 0.00005
      end
    end

    test "generating inverse matrix for D65 to sRGB" do
      expected = [
        [3.2404542, -1.5371385, -0.4985314],
        [-0.9692660, 1.8760108, 0.0415560],
        [0.0556434, -0.2040259, 1.0572252]
      ]

      actual = RgbXyzMatrix.xyz_to_rgb(:d65, :srgb)

      for y <- 0..2, x <- 0..2 do
        assert_in_delta Enum.at(Enum.at(expected, y), x), Enum.at(Enum.at(actual, y), x), 0.00005
      end
    end
  end

  describe "sRGB/D50" do
    test "generating matrix for sRGB to D50" do
      expected = [
        [0.4360747, 0.3850649, 0.1430804],
        [0.2225045, 0.7168786, 0.0606169],
        [0.0139322, 0.0971045, 0.7141733]
      ]

      actual = RgbXyzMatrix.matrix(:srgb, :d50)

      for y <- 0..2, x <- 0..2 do
        assert_in_delta Enum.at(Enum.at(expected, y), x), Enum.at(Enum.at(actual, y), x), 0.00005
      end
    end
  end
end
