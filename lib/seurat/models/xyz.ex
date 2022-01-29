defmodule Seurat.Models.Xyz do
  @moduledoc """
  A color modeled in the CIE 1931 XYZ colorspace

  The XYZ colorspace provides a quantitative link between perceived colors and
  the wavelengths that produce them, providing a non-device-specific way to
  define the colors we see using numbers. Because of this it is often used when
  converting from one colorspace to another.

  ## Fields

  - `x`: roughly equivalent to a response curve for the cone cells in the human
    eye. Its range depends on the associated white point but for the default D65
    it goes from 0.0 to 0.95047
  - `y`: the luminance of the color, where 0.0 is black and 1.0 is white
  - `z`: is roughly equivalent to the blue stimulation (of CIE RGB). Its range
    depends on the associated white point but for the default D65 it goes from
    0.0 to 1.08883
  - `white_point` - the white point representing the color's illuminant and
    observer. By default this is D65 for 2° observer
  """

  defstruct [:x, :y, :z, :white_point]

  @type t :: %__MODULE__{
          x: float,
          y: float,
          z: float,
          white_point: Seurat.illuminant()
        }

  @doc """
  Creates a new XYZ color from the given values.

  ## Examples

      iex> Xyz.new(0.54318, 0.5, 1.01)
      #Seurat.Models.Xyz<0.5432, 0.5, 1.01 (D65)>

  """
  @spec new(number, number, number, Seurat.illuminant() | nil) :: __MODULE__.t()
  def new(x, y, z, white_point \\ :d65)
      when is_number(x) and is_number(y) and is_number(z) do
    %__MODULE__{
      x: x,
      y: y,
      z: z,
      white_point: white_point
    }
  end

  def adapt_into(%__MODULE__{white_point: source_wp} = color, target_wp) do
    matrix = Seurat.Conversions.ChromaticAdaptation.matrix_for(source_wp, target_wp)
    [x, y, z] = Seurat.Utils.Matrix.mulitply_vector([color.x, color.y, color.z], matrix)

    new(x, y, z, target_wp)
  end

  use Seurat.Inspect, [:x, :y, :z]
  use Seurat.Model, "CIE"

  defimpl Seurat.Conversions.FromRgb do
    def convert(%{red: r, green: g, blue: b}) do
      with [r, g, b] <- Enum.map([r, g, b], &inverse_companding/1) do
        x = calculate_channel(r, g, b, 0.4124564, 0.3575761, 0.1804375)
        y = calculate_channel(r, g, b, 0.2126729, 0.7151522, 0.0721750)
        z = calculate_channel(r, g, b, 0.0193339, 0.1191920, 0.9503041)

        Seurat.Models.Xyz.new(x, y, z)
      end
    end

    # For now we're only using sRGB, so that's the companding we use
    defp inverse_companding(v) when v <= 0.04045, do: v / 12.92

    defp inverse_companding(v) do
      :math.pow((v + 0.055) / 1.055, 2.4)
    end

    defp calculate_channel(r, g, b, m1, m2, m3) do
      r * m1 + g * m2 + b * m3
    end
  end

  defimpl Seurat.Conversions.FromXyz do
    def convert(xyz), do: xyz
  end

  defimpl Seurat.Conversions.FromLab do
    @e 216 / 24389
    @k 24389 / 27

    def convert(%{l: l, a: a, b: b, white_point: wp}) do
      %{x: ref_x, y: ref_y, z: ref_z} = Seurat.WhitePoint.for(wp)
      fy = (l + 16) / 116
      fz = fy - b / 200
      fx = a / 500 + fy

      xr =
        if :math.pow(fx, 3) > @e do
          :math.pow(fx, 3)
        else
          (116 * fx - 16) / @k
        end

      zr =
        if :math.pow(fz, 3) > @e do
          :math.pow(fz, 3)
        else
          (116 * fz - 16) / @k
        end

      yr =
        if l > @k * @e do
          :math.pow((l + 16) / 116, 3)
        else
          l / @k
        end

      x = xr * ref_x
      y = yr * ref_y
      z = zr * ref_z

      Seurat.Models.Xyz.new(x, y, z)
    end
  end

  defimpl Seurat.Conversions.FromYxy do
    def convert(%{x: x, y: y, luma: luma}) do
      if y == 0 do
        Seurat.Models.Xyz.new(0, 0, 0)
      else
        xyz_x = x * luma / y
        xyz_z = (1 - x - y) * luma / y

        Seurat.Models.Xyz.new(xyz_x, luma, xyz_z)
      end
    end
  end

  defimpl Seurat.Conversions.FromLuv do
    @e 216 / 24389
    @k 24389 / 27

    def convert(%{l: l, u: u, v: v, white_point: wp}) do
      %{x: ref_x, y: ref_y, z: ref_z} = Seurat.WhitePoint.for(wp)

      if l * u * v == 0 do
        Seurat.Models.Xyz.new(0, 0, 0)
      else
        y =
          if l > @k * @e do
            :math.pow((l + 16) / 116, 3)
          else
            l / @k
          end

        u0 = 4 * ref_x / (ref_x + 15 * ref_y + 3 * ref_z)
        v0 = 9 * ref_y / (ref_x + 15 * ref_y + 3 * ref_z)

        a = (52 * l / (u + 13 * l * u0) - 1) / 3
        b = -5 * y
        c = -1 / 3
        d = y * (39 * l / (v + 13 * l * v0) - 5)

        x = (d - b) / (a - c)
        z = x * a + b

        Seurat.Models.Xyz.new(x, y, z)
      end
    end
  end
end
