defmodule Seurat.Models.Hsv do
  @moduledoc """
  A color modeled in the HSV (hue, saturation, value) colorspace.

  In contrast to the RGB color model, HSV was created to be a more
  human-analogue color model, defining a color by its hue, saturation and value,
  rather than a combination of red, green, and blue hues.

  This colorspace is modeled as a cylinder, with the `hue` is the angle around
  the cylinder, `saturation` is the distance from the center (the center being
  pure white, the outer rim being the most "colorful"), and `value` being the
  distance from the cylinder's base (the bottom being black, and the top being
  the most vibrant). This models how colors appear under light.

  This colorspace makes certain operations on colors especially straightforword,
  such as changing the hue from red to green (rotation around the cylinder) or
  dulling a color (reducing the value).

  ## Fields

  * `hue` - the radial angle of the color's hue, given in degrees in the range
    [0.0, 360.0).
  * `saturation` - the "colorfulness" of the color, in the range [0.0, 1.0]. 0
    will produce a full white, while 1 will produce a highly saturated color
  * `value` - the brightness of the color, in the range [0.0, 1.0]. 0 will
    give full black, while 1 will produce the brightest version of the color
  """

  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          value: float
        }

  @doc """
  Creates a new HSV color from the given values.

  ## Examples

      iex> Hsv.new(120, 0.5, 0.75)
      #Seurat.Models.Hsv<120.0, 0.5, 0.75>
  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, saturation, value)
      when is_number(hue) and is_number(saturation) and is_number(value) do
    %__MODULE__{
      hue: hue / 1,
      saturation: saturation / 1,
      value: value / 1
    }
  end

  use Seurat.Inspect, [:hue, :saturation, :value]
end
