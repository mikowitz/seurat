defmodule Seurat.Models.Lchuv do
  @moduledoc """
  A color modeled in the CIE L\\*C\\*uv h°uv colorspace, a polar version of CIE L*u*v*.

  L*C*uv h°uv shares its range and perceptual uniformity with L*u*v*, but is a
  cylindrical color space, like HSL and HSV, which means it can be used to
  change the hue and saturation of a color, while preserving its other visual
  aspects.

  ## Fields

  - `l` - the lightness of the color. 0.0 gives absolute black and 100.0 gives
    the brightest white.
  - `c` - the colorfulness (chroma) of the color. Similar to saturation. 0.0
    gives gray colors, and values equal to or greater than 130-180 gives fully
    saturated colors. The range extends beyond 180, but 180 is a suitable upper
    limit that includes the entire L\\*u\\*v\\* gamut.
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
  Creates a new L\\*C\\*h°uv color from the given values.
  ## Examples

      iex> Lchuv.new(50, 125, 100)
      #Seurat.Models.Lchuv<50.0, 125.0, 100.0 (D65)>

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

  defimpl Seurat.Conversions.FromLchuv do
    def convert(lchuv), do: lchuv
  end

  defimpl Seurat.Conversions.FromLuv do
    def convert(%{l: l, u: u, v: v}) do
      c = :math.sqrt(u * u + v * v)

      h = :math.atan2(v, u) |> rads_to_degs

      Seurat.Models.Lchuv.new(l, c, h)
    end

    @rads_per_deg 0.01745329252
    def rads_to_degs(rad), do: rad / @rads_per_deg
  end

  defimpl Seurat.Conversions.FromHsluv do
    import Seurat.Conversions.HsluvHelpers

    def convert(%{hue: h, l: l}) when l > 99.9999999, do: Seurat.Models.Lchuv.new(100, 0, h)
    def convert(%{hue: h, l: l}) when l < 0.00000001, do: Seurat.Models.Lchuv.new(0, 0, h)

    def convert(%{hue: h, saturation: s, l: l}) do
      max_chroma = l |> get_bounds() |> max_chroma_at_hue(h)

      c = s * max_chroma * 0.01

      Seurat.Models.Lchuv.new(l, c, h)
    end
  end
end
