defmodule Seurat.Conversions.RgbXyzMatrix do
  @moduledoc """
  This module holds the logic for generating conversion matrices between RGB and
  XYZ colorspaces.
  """

  alias Seurat.Utils.Matrix

  def matrix(rgb_working_space, white_point) do
    # :d65 is the native white point for srgb, so this needs to be pulled
    # from the rgb_working_space
    %{x: xw, y: yw, z: zw} = Seurat.WhitePoint.for(:d65)

    %{
      red: %{x: xr, y: yr},
      green: %{x: xg, y: yg},
      blue: %{x: xb, y: yb}
    } = primary_for(rgb_working_space)

    mxr = xr / yr
    myr = 1
    mzr = (1 - xr - yr) / yr
    mxg = xg / yg
    myg = 1
    mzg = (1 - xg - yg) / yg

    mxb = xb / yb
    myb = 1
    mzb = (1 - xb - yb) / yb

    [
      [xr, xg, xb],
      [yr, yg, yb],
      [zr, zg, zb]
    ] =
      Matrix.invert([
        [mxr, mxg, mxb],
        [myr, myg, myb],
        [mzr, mzg, mzb]
      ])

    [sr, sg, sb] = [
      xr * xw + xg * yw + xb * zw,
      yr * xw + yg * yw + yb * zw,
      zr * xw + zg * yw + zb * zw
    ]

    m = [
      [sr * mxr, sg * mxg, sb * mxb],
      [sr * myr, sg * myg, sb * myb],
      [sr * mzr, sg * mzg, sb * mzb]
    ]

    adaptation_matrix = Seurat.Conversions.ChromaticAdaptation.matrix_for(:d65, white_point)

    Matrix.multiply(adaptation_matrix, m)
  end

  def xyz_to_rgb(white_point, rgb_working_space) do
    matrix(rgb_working_space, white_point) |> Matrix.invert()
  end

  defp primary_for(:srgb) do
    %{
      red: %{x: 0.64, y: 0.33, luma: 0.212656},
      green: %{x: 0.3, y: 0.6, luma: 0.715158},
      blue: %{x: 0.15, y: 0.06, luma: 0.072186}
    }
  end
end
