defmodule Seurat.Models.LabTest do
  use Seurat.ColorCase, async: true

  alias Seurat.Models.Lab
  doctest Lab

  describe "conversions" do
    test "to Lab" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, lab: lab} ->
        actual = Seurat.to(lab, Lab)

        assert_colors_equal(lab, actual, color)
      end)
    end

    test "to XYZ" do
      ColorMine.data()
      |> Enum.map(fn %{color: color, lab: lab, xyz: expected} ->
        actual = Seurat.to(lab, Seurat.Models.Xyz)

        assert_colors_equal(expected, actual, color)
      end)
    end
  end
end
