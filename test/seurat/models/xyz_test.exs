defmodule Seurat.Models.XyzTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Xyz
  doctest Xyz

  describe "conversions" do
    test "to XYZ" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, xyz: xyz} ->
        actual = Seurat.to(xyz, Xyz)

        assert_colors_equal(xyz, actual, color)
      end)
    end

    test "to RGB" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, xyz: xyz, rgb: expected} ->
        actual = Seurat.to(xyz, Seurat.Models.Rgb)

        assert_colors_equal(expected, actual, color)
      end)
    end

    test "to Lab" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, xyz: xyz, lab: expected} ->
        actual = Seurat.to(xyz, Seurat.Models.Lab)

        assert_colors_equal(expected, actual, color, 0.1)
      end)
    end

    test "to Yxy" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, xyz: xyz, yxy: expected} ->
        actual = Seurat.to(xyz, Seurat.Models.Yxy)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
