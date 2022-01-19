defmodule Seurat.Models.Luv do
  @moduledoc """
  Models a color in the CIELUV (L*u*v*) colorspace.

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
  Creates a new L\*u\*v\* color from the given values

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
end
