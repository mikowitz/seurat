defmodule Seurat.Models.Rgb do
  @moduledoc """
  A color modeled in sRGB colorspace

  Standard RGB (sRGB) is a non-linear RGB colorspace used for screen displays
  and digital media. The non-linearity accounts for the fact that our eyes are
  more sensitive to color variation at low intensities (near black) than at high
  intensities (near white). When people talk about "RGB", this is almost always
  what they mean.

  ## Fields

  - `red`: the amount of red light in the color, where 0.0 is no red light, and
    1.0 is the highest displayable amount.
  - `green`: the amount of green light in the color, where 0.0 is no green
    light, and 1.0 is the highest displayable amount.
  - `blue`: the amount of blue light in the color, where 0.0 is no blue light,
    and 1.0 is the highest displayable amount.

  """

  defstruct [:red, :green, :blue, :profile]

  @type t :: %__MODULE__{
          red: float,
          green: float,
          blue: float,
          profile: Seurat.rgb_profile()
        }

  @doc """
  Creates a new RGB color from the given values.

  ## Examples

  When no RGB profile is given, `Seurat` assumes sRGB

      iex> Rgb.new(0.5, 0.5, 1)
      #Seurat.Models.Rgb<0.5, 0.5, 1.0 (sRGB)>

  If a profile is specificed, creates the color using that profile

      iex> Rgb.new(0.5, 0, 1, :adobe)
      #Seurat.Models.Rgb<0.5, 0.0, 1.0 (Adobe RGB)>

  """
  @spec new(number, number, number, Seurat.rgb_profile()) :: __MODULE__.t()
  def new(red, green, blue, profile \\ :srgb)
      when is_number(red) and is_number(green) and is_number(blue) do
    %__MODULE__{
      red: red / 1,
      green: green / 1,
      blue: blue / 1,
      profile: profile
    }
  end

  @doc """
  Checks whether the color is displayable in RGB colorspace.

  ## Examples

      iex> Rgb.new(0.5, 0.5, 0.5) |> Rgb.within_bounds?()
      true

      iex> Rgb.new(1, 0.5, 0) |> Rgb.within_bounds?()
      true

      iex> Rgb.new(1.01, 0.5, -0.01) |> Rgb.within_bounds?()
      false

  """
  @spec within_bounds?(__MODULE__.t()) :: boolean
  def within_bounds?(%__MODULE__{red: r, green: g, blue: b}) do
    r >= 0 and r <= 1 and
      g >= 0 and g <= 1 and
      b >= 0 and b <= 1
  end

  use Seurat.Inspect, [:red, :green, :blue]
  use Seurat.Model, "RGB"

  defimpl Seurat.Conversions.FromRgb do
    def convert(rgb), do: rgb
  end

  defimpl Seurat.Conversions.FromHsv do
    # https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB_alternative
    def convert(%{hue: h, saturation: s, value: v}) do
      f = fn n ->
        k = :math.fmod(n + h / 60, 6)
        v - v * s * max(0, Enum.min([k, 4 - k, 1]))
      end

      [r, g, b] = Enum.map([5, 3, 1], &f.(&1))

      Seurat.Models.Rgb.new(r, g, b)
    end
  end

  defimpl Seurat.Conversions.FromHsl do
    # https://en.wikipedia.org/wiki/HSL_and_HSV#HSL_to_RGB_alternative
    def convert(%{hue: h, saturation: s, lightness: l}) do
      f = fn n ->
        k = :math.fmod(n + h / 30, 12)
        a = s * min(l, 1 - l)
        l - a * max(-1, Enum.min([k - 3, 9 - k, 1]))
      end

      [r, g, b] = Enum.map([0, 8, 4], &f.(&1))

      Seurat.Models.Rgb.new(r, g, b)
    end
  end

  defimpl Seurat.Conversions.FromXyz do
    def convert(%{x: x, y: y, z: z, white_point: wp}) do
      [
        [a, b, c],
        [d, e, f],
        [g, h, i]
      ] = Seurat.Conversions.RgbXyzMatrix.xyz_to_rgb(wp, :srgb)

      red = calculate_channel(x, y, z, a, b, c)
      green = calculate_channel(x, y, z, d, e, f)
      blue = calculate_channel(x, y, z, g, h, i)

      [r, g, b] = Enum.map([red, green, blue], &companding/1)

      Seurat.Models.Rgb.new(r, g, b)
    end

    defp companding(v) when v <= 0.0031308, do: 12.92 * v
    defp companding(v), do: :math.pow(1.055 * v, 1 / 2.4) - 0.055

    defp calculate_channel(r, g, b, m1, m2, m3) do
      r * m1 + g * m2 + b * m3
    end
  end
end
