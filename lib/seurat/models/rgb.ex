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

  defstruct [:red, :green, :blue]

  @type t :: %__MODULE__{
          red: float,
          green: float,
          blue: float
        }

  @doc """
  Creates a new RGB color from the given values.

  ## Examples

      iex> Rgb.new(0.5, 0.5, 1)
      #Seurat.Models.Rgb<0.5, 0.5, 1.0>

  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(red, green, blue) when is_number(red) and is_number(green) and is_number(blue) do
    %__MODULE__{
      red: red / 1,
      green: green / 1,
      blue: blue / 1
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

  defimpl Seurat.Conversions.FromRgb do
    def convert(rgb), do: rgb
  end
end
