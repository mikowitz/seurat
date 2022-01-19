defmodule Seurat.Models.Hwb do
  @moduledoc """
  Models a color in the HWB (hue, whiteness, blackness) colorspace.

  HWB is a cylindrical version of RGB closely related to HSV and HSL.
  It describes colors by starting with a hue, like other cylindrical models, and
  then adds degrees of whiteness and blackness to that base hue.

  Because colors are constructed by lightening or darkening a starting hue, it
  is a particularly intuitive system for humans to use.

  ## Fields

  * `hue` - the radial angle of the color's hue, given in degrees in the range
    [0.0, 360.0).
  * `whiteness` - specifies the amount of white to mix into the hue, in the
    range [0.0, 1.0]. A value of 1 will always result in a full white, and 0
    will result in a color shade (a mixture of the original hue with black)
    based on the `hue` and `blackness` values.
  * `blackness` - specifies the amount of black to mix into the hue, in the
    range [0.0, 1.0]. A value of 1 will always result in a full black, and 0
    will result in a color tint (a mixture of the original hue with black) based
    on the `hue` and `whiteness` values.

  """

  defstruct [:hue, :whiteness, :blackness]

  @type t :: %__MODULE__{
          hue: float,
          whiteness: float,
          blackness: float
        }

  @doc """
  Creates a new HWB color from the given values

  ## Examples

      iex> Hwb.new(120, 0.5, 0)
      #Seurat.Models.Hwb<120.0, 0.5, 0.0>

  As hue is measured on a circle, its value will be normalized to be in the
  range between [0 and 360)

      iex> Hwb.new(-15, 0.5, 0.5)
      #Seurat.Models.Hwb<345.0, 0.5, 0.5>

      iex> Hwb.new(800, 0.5, 0.5)
      #Seurat.Models.Hwb<80.0, 0.5, 0.5>
  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, whiteness, blackness)
      when is_number(hue) and is_number(whiteness) and is_number(blackness) do
    %__MODULE__{
      hue: normalize_hue(hue / 1),
      whiteness: whiteness / 1,
      blackness: blackness / 1
    }
  end

  defp normalize_hue(hue) when hue < 0, do: normalize_hue(hue + 360)
  defp normalize_hue(hue), do: :math.fmod(hue, 360)

  use Seurat.Inspect, [:hue, :whiteness, :blackness]
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

      w = cmin
      b = 1 - cmax

      Seurat.Models.Hwb.new(h, w, b)
    end
  end

  defimpl Seurat.Conversions.FromHsv do
    def convert(%{hue: h, saturation: s, value: v}) do
      w = (1 - s) * v
      b = 1 - v

      Seurat.Models.Hwb.new(h, w, b)
    end
  end

  defimpl Seurat.Conversions.FromHwb do
    def convert(hwb), do: hwb
  end
end
