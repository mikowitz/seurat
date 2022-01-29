defmodule Seurat.Models.Hsluv do
  @moduledoc """
  A color modeled in the HSLuv color space.

  HSLuv is a cylindrical version of the CIELUV model. It is therefore similar to
  LCHuv, but with the added benefit of normalizing the chroma values into a
  uniform saturation range [0.0, 100.0]. This makes it possible to pick a
  saturation value independently of lightness and hue, and so is more convenient
  for generating colors.

  ## Fields

  - `hue` - the radial angle of the color's hue, given in degrees in the range
    [0.0, 360.0).
  - `saturation` - the "colorfulness" of the color, as a percentage of the
    maximum chroma. 0.0 gives grayscale colors, 100.0 gives maximally saturated
    colors.
  - `l` - determines how light the color will look. 0.0 gives black, 50.0 gives
    a clear color, and 100.0 gives white.
  - `white_point` - the white point representing the color's illuminant and
    observer. By default this is D65 for 2° observer

  """

  defstruct [:hue, :saturation, :l, :white_point]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          l: float,
          white_point: Seurat.illuminant()
        }

  @doc """
  Creates a new HSLuv color from the given values.

  ## Examples

      iex> Hsluv.new(120, 75, 75.32)
      #Seurat.Models.Hsluv<120.0, 75.0, 75.32 (D65)>

  As hue is measured on a circle, its value will be normalized to be in the
  range between [0 and 360)

      iex> Hsluv.new(-10, 50, 50)
      #Seurat.Models.Hsluv<350.0, 50.0, 50.0 (D65)>

  """
  @spec new(number, number, number, Seurat.illuminant() | nil) :: __MODULE__.t()
  def new(hue, saturation, l, white_point \\ :d65)
      when is_number(hue) and is_number(saturation) and is_number(l) do
    %__MODULE__{
      hue: normalize_hue(hue / 1),
      saturation: saturation / 1,
      l: l / 1,
      white_point: white_point
    }
  end

  defp normalize_hue(hue) when hue < 0, do: normalize_hue(hue + 360)
  defp normalize_hue(hue), do: :math.fmod(hue, 360)

  use Seurat.Inspect, [:hue, :saturation, :l]
  use Seurat.Model, "Cylindrical"

  defimpl Seurat.Conversions.FromHsluv do
    def convert(hsluv), do: hsluv
  end

  defimpl Seurat.Conversions.FromLchuv do
    import Seurat.Conversions.HsluvHelpers

    def convert(%{l: l, h: h}) when l > 99.9999999, do: Seurat.Models.Hsluv.new(h, 0, 100)
    def convert(%{l: l, h: h}) when l < 0.00000001, do: Seurat.Models.Hsluv.new(h, 0, 0)

    def convert(%{l: l, c: c, h: h}) do
      max_chroma = l |> get_bounds() |> max_chroma_at_hue(h)

      s = c / max_chroma * 100

      Seurat.Models.Hsluv.new(h, s, l)
    end
  end
end
