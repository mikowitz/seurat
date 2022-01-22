defmodule Seurat.Models.Yxy do
  @moduledoc """
  The CIE 193 Yxy (also abbreviated xyY) colorspace.

  This is a luminance-chromaticity color space derived from `Seurat.Models.Xyz`,
  and is widely used to define colors. The CIE chromaticity diagram is a plot
  of the `x` and `y` values of this colorspace.

  ## Fields

  `x` - the x chromacity coordinate. Typical range is between 0.0 and 1.0
  `y` - the y chromacity coordinate. Typical range is between 0.0 and 1.0
  `luma` - (Y) is the measure of brightness of the color. Its range is 0.0
    (black) to 1.0 (white)
  """

  defstruct [:x, :y, :luma]

  @type t :: %__MODULE__{
          x: float,
          y: float,
          luma: float
        }

  @doc """
  Creates a new Yxy color from the given values.

  ## Examples

      iex> Yxy.new(0.54313, 0.5, 0.9)
      #Seurat.Models.Yxy<0.5431, 0.5, 0.9>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(x, y, luma) when is_number(x) and is_number(y) and is_number(luma) do
    %__MODULE__{
      x: x,
      y: y,
      luma: luma
    }
  end

  use Seurat.Inspect, [:x, :y, :luma]
  use Seurat.Model, "CIE"

  defimpl Seurat.Conversions.FromXyz do
    def convert(%{x: x, y: y, z: z}) do
      if x + y + z == 0 do
        Seurat.Models.Yxy.new(0, 0, 0)
      else
        yxy_x = x / (x + y + z)
        yxy_y = y / (x + y + z)

        Seurat.Models.Yxy.new(yxy_x, yxy_y, y)
      end
    end
  end

  defimpl Seurat.Conversions.FromYxy do
    def convert(yxy), do: yxy
  end
end
