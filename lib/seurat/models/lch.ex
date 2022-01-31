defmodule Seurat.Models.Lch do
  @moduledoc """
  A color modeled in the CIE L\\*C\\*h° colorspace, a polar version of CIELAB.

  Lch shares the visual gamut and perceptual uniformity of L\\*a\\*b\\*, but is
  a cylindrical color space, like HSV and HSL, which means it can be used to
  change the hue and saturation of a color while preserving its other visual
  aspects.

  ## Fields

  - `l` - the lightness of the color. 0.0 gives absolute black and 100.0 gives
    the brightest white.
  - `c` - the colorfulness (chroma) of the color. Similar to saturation. 0.0 gives
    gray colors, and values equal to or greater than 128 gives fully saturated
    colors. The range extends beyond 128, but 128 is a suitable upper limit for
    downsampling to sRGB or L\\*a\\*b\\*.
  - `h` - the hue of the color in degrees.
  - `white_point` - the white point associated with the color's illuminant and
    observer. By default this is D65 for 2° observer

  """

  defstruct [:l, :c, :h, :white_point]

  @type t :: %__MODULE__{
          l: float,
          c: float,
          h: float,
          white_point: Seurat.illuminant()
        }

  @doc """
  Creates a new L\\*C\\*h° color from the given values.
  ## Examples

      iex> Lch.new(75, 100, 120)
      #Seurat.Models.Lch<75.0, 100.0, 120.0 (D65)>

  """
  @spec new(number, number, number, Seurat.illuminant() | nil) :: __MODULE__.t()
  def new(l, c, h, white_point \\ :d65)
      when is_number(l) and is_number(c) and is_number(h) do
    %__MODULE__{
      l: l / 1,
      c: c / 1,
      h: normalize_hue(h / 1),
      white_point: white_point
    }
  end

  defp normalize_hue(hue) when hue < 0, do: normalize_hue(hue + 360)
  defp normalize_hue(hue), do: :math.fmod(hue, 360)

  use Seurat.Inspect, [:l, :c, :h]
  use Seurat.Model, "CIE"

  defimpl Seurat.Conversions.FromLch do
    def convert(lch), do: lch
  end

  defimpl Seurat.Conversions.FromLab do
    def convert(%{l: l, a: a, b: b}) do
      c = :math.sqrt(a * a + b * b)

      h = :math.atan2(b, a) |> rads_to_degs

      Seurat.Models.Lch.new(l, c, h)
    end

    @rads_per_deg 0.01745329252
    def rads_to_degs(rad), do: rad / @rads_per_deg
  end
end
