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

  As hue is measured on a circle, its value will be normalized to be in the
  range between [0 and 360)

      iex> Hsv.new(-10, 0.5, 0.5)
      #Seurat.Models.Hsv<350.0, 0.5, 0.5>

      iex> Hsv.new(400, 0.5, 0.5)
      #Seurat.Models.Hsv<40.0, 0.5, 0.5>
  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, saturation, value)
      when is_number(hue) and is_number(saturation) and is_number(value) do
    %__MODULE__{
      hue: normalize_hue(hue / 1),
      saturation: saturation / 1,
      value: value / 1
    }
  end

  defp normalize_hue(hue) when hue < 0, do: normalize_hue(hue + 360)
  defp normalize_hue(hue), do: :math.fmod(hue, 360)

  use Seurat.Inspect, [:hue, :saturation, :value]
  use Seurat.Model, "Cylindrical"

  defimpl Seurat.Conversions.FromRgb do
    def convert(%{red: r, green: g, blue: b}) do
      {cmin, cmax} = Enum.min_max([r, g, b])
      delta = cmax - cmin

      h =
        cond do
          delta == 0 -> 0
          cmax == r -> 60 * :math.fmod((g - b) / delta, 6)
          cmax == g -> 60 * ((b - r) / delta + 2)
          cmax == b -> 60 * ((r - g) / delta + 4)
        end

      s =
        case cmax do
          0.0 -> 0.0
          _ -> delta / cmax
        end

      v = cmax

      Seurat.Models.Hsv.new(h, s, v)
    end
  end

  defimpl Seurat.Conversions.FromHsv do
    def convert(hsv), do: hsv
  end

  defimpl Seurat.Conversions.FromHsl do
    def convert(%{hue: h, saturation: s, lightness: l}) do
      v = l + s * min(l, 1 - l)

      s =
        if v == 0 do
          0
        else
          2 * (1 - l / v)
        end

      Seurat.Models.Hsv.new(h, s, v)
    end
  end

  defimpl Seurat.Conversions.FromHwb do
    def convert(%{hue: h, whiteness: w, blackness: b}) do
      case 1 - b do
        0.0 ->
          Seurat.Models.Hsv.new(h, 0, 0)

        v ->
          s = 1 - w / v
          Seurat.Models.Hsv.new(h, s, v)
      end
    end
  end
end
