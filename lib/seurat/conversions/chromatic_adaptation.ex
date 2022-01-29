defmodule Seurat.Conversions.ChromaticAdaptation do
  @moduledoc """
  Functions for managing chromatic adaptation between different reference white
  points.
  """

  alias Seurat.Utils.Matrix

  @bradford [
    [0.8951, 0.2664, -0.1614],
    [-0.7502, 1.7135, 0.0367],
    [0.0389, -0.0685, 1.0296]
  ]

  def matrix_for(source, source), do: Matrix.identity()

  def matrix_for(source, destination) do
    %{x: xs, y: ys, z: zs} = Seurat.WhitePoint.for(source)
    %{x: xd, y: yd, z: zd} = Seurat.WhitePoint.for(destination)
    [rs, gs, bs] = Matrix.mulitply_vector([xs, ys, zs], @bradford)
    [rd, gd, bd] = Matrix.mulitply_vector([xd, yd, zd], @bradford)

    m = [
      [rd / rs, 0, 0],
      [0, gd / gs, 0],
      [0, 0, bd / bs]
    ]

    @bradford
    |> Matrix.invert()
    |> Matrix.multiply(m)
    |> Matrix.multiply(@bradford)
  end
end
