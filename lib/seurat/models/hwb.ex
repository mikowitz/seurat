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
  """
  @spec new(number, number, number) :: __MODULE__.t()
  def new(hue, whiteness, blackness)
      when is_number(hue) and is_number(whiteness) and is_number(blackness) do
    %__MODULE__{
      hue: hue / 1,
      whiteness: whiteness / 1,
      blackness: blackness / 1
    }
  end

  use Seurat.Inspect, [:hue, :whiteness, :blackness]
end
