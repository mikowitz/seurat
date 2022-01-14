defmodule Seurat.Models.Xyz do
  @moduledoc """
  A color modeled in the CIE 1931 XYZ colorspace

  The XYZ colorspace provides a quantitative link between perceived colors and
  the wavelengths that produce them, providing a non-device-specific way to
  define the colors we see using numbers. Because of this it is often used when
  converting from one colorspace to another.

  ## Fields

  - `x`: roughly equivalent to a response curve for the cone cells in the human
    eye. Its range depends on the associated white point but for the default D65
    it goes from 0.0 to 0.95047
  - `y`: the luminance of the color, where 0.0 is black and 1.0 is white
  - `z`: is roughly equivalent to the blue stimulation (of CIE RGB). Its range
    depends on the associated white point but for the default D65 it goes from
    0.0 to 1.08883
  """

  defstruct [:x, :y, :z]

  @type t :: %__MODULE__{
          x: float,
          y: float,
          z: float
        }

  @doc """
  Creates a new XYZ color from the given values.

  ## Examples

      iex> Xyz.new(0.54318, 0.5, 1.01)
      #Seurat.Models.Xyz<0.5432, 0.5, 1.01>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(x, y, z) when is_number(x) and is_number(y) and is_number(z) do
    %__MODULE__{
      x: x,
      y: y,
      z: z
    }
  end

  use Seurat.Inspect, [:x, :y, :z]
end
