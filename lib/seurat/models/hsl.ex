defmodule Seurat.Models.Hsl do
  @moduledoc """
  A color modeled in the HSL (hue, saturation, lightness) colorspace.

  Similar to the `Seurat.Hsv` colorspace, `Hsl` is also a cylindrical color
  model, but rather than modeling how colors appear under light, it models
  how paints mix to create color. Adding `lightness` brightens the color, with
  a lightness value of 1 corresponding to full white, rather than than a fully
  saturated color.

  ## Fields

  * `hue` - the radial angle of the color's hue, given in degrees in the range
    [0.0, 360.0).
  * `saturation` - the "colorfulness" of the color, in the range [0.0, 1.0]. 0
    will produce a full white, while 1 will produce a highly saturated color
  * `lightness` - the amount of white added to the color, in the range
    [0.0, 1.0]. 0 will produce full black, while a lightness of `1` results in
    a full white.
  """

  defstruct [:hue, :saturation, :lightness]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          lightness: float
        }

  @doc """
  Creates a new HSL color from the given values.

  ## Examples

      iex> Hsl.new(185.78, 0.12345, 0.1)
      #Seurat.Models.Hsl<185.78, 0.1235, 0.1>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, saturation, lightness)
      when is_number(hue) and is_number(saturation) and is_number(lightness) do
    %__MODULE__{
      hue: hue / 1,
      saturation: saturation / 1,
      lightness: lightness / 1
    }
  end

  use Seurat.Inspect, [:hue, :saturation, :lightness]
end
