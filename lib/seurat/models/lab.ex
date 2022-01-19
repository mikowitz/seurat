defmodule Seurat.Models.Lab do
  @moduledoc """
  A color modeled in the CIELAB (L\*a\*b\*) colorspace.

  CIELAB is intended as a perceptually uniform space, meaning that a given
  numerical change in color value corresponds to a similar perceived change in
  color. L*a*b* is not truly perceptually uniform, especially in the blues, but
  is still useful for detecting small color differences.

  The CIELAB space is 3-dimensional, and covers the entire range of human color
  perception. Because of this, and its near perceptual uniformity, it is useful
  for converting between other color spaces, as well as color manipulation.

  It is based on the opponent color model of human vision, with opposing pairs
  of red/green and yellow/blue.

  ## Fields

  - `l` - the lightness of the color. 0 gives black and 100 gives white.
  - `a` - the red/green opponent colors. Negative values move towards green, and
    positive values towards red.
  - `b` - the blue/yellow opponent colors. Negative values toward blue and
    positive values toward yellow.

  The `a` and `b` values are unbounded, and can extend beyond ±150 to cover the
  entire human color gamut. However, not every L\*a\*b\* color is necessarily
  convertible to other, more limited color spaces. For example, values for `a`
  and `b` outside of the range [-127, 128] cannot be converted exactly to sRGB
  colors.
  """

  defstruct [:l, :a, :b]

  @type t :: %__MODULE__{
          l: float,
          a: float,
          b: float
        }

  @doc """
  Creates a new L\*a\*b\* color from the given values.

  ## Examples

      iex> Lab.new(75, -10, 50)
      #Seurat.Models.Lab<75.0, -10.0, 50.0>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(l, a, b) when is_number(l) and is_number(a) and is_number(b) do
    %__MODULE__{
      l: l / 1,
      a: a / 1,
      b: b / 1
    }
  end

  use Seurat.Inspect, [:l, :a, :b]
  use Seurat.Model, "CIE"
end
