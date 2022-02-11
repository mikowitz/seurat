defmodule Seurat.Models.Rgb do
  @moduledoc """
  A color modeled in an RGB colorspace

  ## Linear vs non-linear RGB

  In digital images, colors are often stored in a gamma corrected -- converted
  using a non-linear transfer function into a format like sRGB (Standard RGB) --
  format. This is done both for compression, and to account for the fact that
  the output from the electron gun in older CRT monitors was non-linear. It also
  accounts for the fact that human eyes are more sensitive to color variation
  at low intensities (near black) than at high intensities (near white).

  This non-linearity means that operations (addition, multiplication,
  interpolaction, etc.) on colors that have have been gamma corrected will not
  return expected results. In order to modify RGB colors, the gamma correction
  must be reversed.

  For example, if you want to modify colors in an image you would follow these
  steps

  1. decode color pixel data from the image
  2. reverse the gamma correction, converting to linear sRGB
  3. perform your modification operations
  4. reapply the gamma correction
  5. encode color data back into an image format to be stored

  ## RGB profiles

  An RGB colorspace profile is defined by two pieces of data:

  1. Its primaries (canonical values for "red", "green" and "blue", defined as
    [`Yxy`](`Seurat.Models.Yxy`) colors)
  2. Its reference white, or [white point](`Seurat.WhitePoint`)

  Seurat provides definitions for the following common RGB profiles

  - Adobe RGB (1998) - a colorspace developed by Adobe in 1998, designed to
    encompass most of the colors achievable by CMYK color printers, but using
    RGB primary colors on computer displays
  - Apple RGB - a colorspace developed by Adobe, not Apple. It is based on the
    classic Apple 13" RGB monitors.
  - ProPhoto RGB - also known as ROMM RGB, it was developed by Kodak to have a
    large gamut with photographic output in mind. Because of its gamut (wider
    even than Wide Gamut RGB), primaries and white point, approximately 13% of
    this colorspace -- including its green and blue primaries -- is made up of
    [imaginary colors](https://en.wikipedia.org/wiki/Impossible_color#Imaginary_colors)
  - sRGB - developed by HP and Microsoft in 1996 for use on monitors, printers,
    and the nascent internet, and it is still the defined standard colorspace
    for the web, and the assumed colorspace for images that are not otherwise
    tagged. It has the smallest gamut, making it impractical for high quality
    photo work, but excellent for portability and web images/design.
  - Wide Gamut RGB - another RGB colorspace developed by Adobe. As its name
    suggests, it is able to display and store a winder range of colors than
    Adobe RGB or sRGB

  When people talk about "RGB", especially in digital and web design, they
  almost always mean "sRGB", so that is the RGB colorspace `Seurat` adopts as
  default. This allows users to use the library as easily as possible, while
  still providing more complexity if required.


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
  - `profile` - the RGB color profile in which the red, green, and blue values
    are defined. See `Seurat.Models.Rgb.Profile` for details. If not specified,
    sRGB is assumed as the default.

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

  alias Seurat.Models.Rgb.Profile
  alias Seurat.Conversions.{RgbXyzMatrix, ChromaticAdaptation}
  alias Seurat.Utils.Matrix

  @doc """
  Converts an RGB color using one profile into another RGB profile

  ## Examples

      iex> adobe = Rgb.new(0.5, 0, 1, :adobe)
      iex> Rgb.into(adobe, :srgb)
      #Seurat.Models.Rgb<0.6991, 0.0, 1.0429 (sRGB)>

  """
  @spec into(__MODULE__.t(), Seurat.rgb_profile()) :: __MODULE__.t()
  def into(%__MODULE__{} = color, target_colorspace) do
    source_wp = Profile.white_point_for(color.profile)
    target_wp = Profile.white_point_for(target_colorspace)

    ca_m = ChromaticAdaptation.matrix_for(source_wp, target_wp)
    out_m = RgbXyzMatrix.xyz_to_rgb(target_wp, target_colorspace)

    m =
      Matrix.multiply(
        out_m,
        Matrix.multiply(
          ca_m,
          RgbXyzMatrix.matrix(color.profile, source_wp)
        )
      )

    [r, g, b] = Matrix.mulitply_vector([color.red, color.green, color.blue], m)

    __MODULE__.new(r, g, b, target_colorspace)
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
