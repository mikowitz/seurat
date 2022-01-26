defmodule Seurat.Models.Luv do
  @moduledoc """
  Models a color in the CIELUV (L\\*u\\*v\\*) colorspace.

  Like CIELAB, CIELUV is a device-independent color space that aims to be
  perceptually uniform. In addition, and in contrast to CIELAB, CIELUV aims to
  be linear for a fixed lightness. That is, additive mixtures of colors at a
  fixed lightness will fall in a line on the CIELUV scale.

  ## Fields

  - `l` - the lightness of the color. 0 gives black and 100 gives white
  - `u` - the range of valid `u` values varies depending on the values of `l`
    and `v`, but its limits are the interval [-84, 176]
  - `v` - the range of valid `v` values varies depending on the values of `l`
    and `u`, but its limits are the interval [-135, 108]

  """

  defstruct [:l, :u, :v]

  @type t :: %__MODULE__{
          l: float,
          u: float,
          v: float
        }

  @doc """
  Creates a new L\\*u\\*v\\* color from the given values

  ## Examples

      iex> Luv.new(85, -50, 100)
      #Seurat.Models.Luv<85.0, -50.0, 100.0>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(l, u, v) when is_number(l) and is_number(u) and is_number(v) do
    %__MODULE__{
      l: l / 1,
      u: u / 1,
      v: v / 1
    }
  end

  use Seurat.Inspect, [:l, :u, :v]
  use Seurat.Model, "CIE"

  defimpl Seurat.Conversions.FromXyz do
    @e 216 / 24389
    @k 24389 / 27
    @ref_x 0.95047
    @ref_y 1.0
    @ref_z 1.08883

    def convert(%{x: x, y: y, z: z}) do
      yr = y / @ref_y

      p_denom = x + 15 * y + 3 * z

      if p_denom == 0 do
        Seurat.Models.Luv.new(0, 0, 0)
      else
        up = 4 * x / (x + 15 * y + 3 * z)
        vp = 9 * y / (x + 15 * y + 3 * z)

        upr = 4 * @ref_x / (@ref_x + 15 * @ref_y + 3 * @ref_z)
        vpr = 9 * @ref_y / (@ref_x + 15 * @ref_y + 3 * @ref_z)

        l =
          if yr > @e do
            116 * :math.pow(yr, 1 / 3) - 16
          else
            @k * yr
          end

        u = 13 * l * (up - upr)
        v = 13 * l * (vp - vpr)

        Seurat.Models.Luv.new(l, u, v)
      end
    end
  end

  defimpl Seurat.Conversions.FromLuv do
    def convert(luv), do: luv
  end

  defimpl Seurat.Conversions.FromLchuv do
    def convert(%{l: l, c: c, h: h}) do
      u = max(c, 0) * as_rads(h, &:math.cos/1)
      v = max(c, 0) * as_rads(h, &:math.sin/1)

      Seurat.Models.Luv.new(l, u, v)
    end

    @rads_per_deg 0.01745329252
    def degs_to_rads(deg), do: deg * @rads_per_deg

    def as_rads(value, func) do
      value |> degs_to_rads() |> func.()
    end
  end
end
