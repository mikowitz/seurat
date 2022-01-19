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

  As hue is measured on a circle, its value will be normalized to be in the
  range between [0 and 360)

      iex> Hsl.new(-20, 0.5, 0.5)
      #Seurat.Models.Hsl<340.0, 0.5, 0.5>

      iex> Hsl.new(405, 0.5, 0.5)
      #Seurat.Models.Hsl<45.0, 0.5, 0.5>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, saturation, lightness)
      when is_number(hue) and is_number(saturation) and is_number(lightness) do
    %__MODULE__{
      hue: normalize_hue(hue / 1),
      saturation: saturation / 1,
      lightness: lightness / 1
    }
  end

  defp normalize_hue(hue) when hue < 0, do: normalize_hue(hue + 360)
  defp normalize_hue(hue), do: :math.fmod(hue, 360)

  use Seurat.Inspect, [:hue, :saturation, :lightness]

  defimpl Seurat.Conversions.FromRgb do
    def convert(%{red: r, green: g, blue: b}) do
      {cmin, cmax} = Enum.min_max([r, g, b])
      delta = cmax - cmin

      l = (cmax + cmin) / 2

      h =
        cond do
          delta == 0 -> 0
          cmax == r -> 60 * :math.fmod((g - b) / delta, 6)
          cmax == g -> 60 * ((b - r) / delta + 2)
          cmax == b -> 60 * ((r - g) / delta + 4)
        end

      s =
        case delta do
          0.0 -> 0.0
          _ -> delta / (1 - abs(2 * l - 1))
        end

      Seurat.Models.Hsl.new(h, s, l)
    end
  end
end
