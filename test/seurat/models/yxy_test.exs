defmodule Seurat.Models.YxyTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Yxy
  doctest Yxy

  describe "conversions" do
    test "to Yxy" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, yxy: yxy} ->
        actual = Seurat.to(yxy, Yxy)

        assert_colors_equal(yxy, actual, color)
      end)
    end

    test "to XYZ" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, yxy: yxy, xyz: expected} ->
        actual = Seurat.to(yxy, Seurat.Models.Xyz)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
