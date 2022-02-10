defmodule Seurat.Models.Rgb.Profile do
  @moduledoc """
  Representation of the primaries and white point for an RGB colorspace profile
  """

  def for(:srgb) do
    %{
      red: %{x: 0.64, y: 0.33, luma: 0.212656},
      green: %{x: 0.3, y: 0.6, luma: 0.715158},
      blue: %{x: 0.15, y: 0.06, luma: 0.072186},
      white_point: :d65
    }
  end

  def for(:adobe) do
    %{
      red: %{x: 0.64, y: 0.33, luma: 0.297361},
      green: %{x: 0.21, y: 0.71, luma: 0.627355},
      blue: %{x: 0.15, y: 0.06, luma: 0.076285},
      white_point: :d65
    }
  end

  def for(:pro_photo) do
    %{
      red: %{x: 0.73747, y: 0.2653, luma: 0.288040},
      green: %{x: 0.1596, y: 0.8404, luma: 0.711874},
      blue: %{x: 0.0366, y: 0.0001, luma: 0.000086},
      white_point: :d50
    }
  end

  def for(:wide_gamut) do
    %{
      red: %{x: 0.735, y: 0.265, luma: 0.258187},
      green: %{x: 0.115, y: 0.826, luma: 0.724938},
      blue: %{x: 0.157, y: 0.018, luma: 0.016875},
      white_point: :d50
    }
  end

  def white_point_for(profile) do
    __MODULE__.for(profile).white_point
  end

  def inverse_companding_function_for(:srgb) do
    fn v ->
      if v <= 0.04045 do
        v / 12.92
      else
        :math.pow((v + 0.055) / 1.055, 2.4)
      end
    end
  end

  def inverse_companding_function_for(:pro_photo) do
    gamma_inverse_companding(1.8)
  end

  def inverse_companding_function_for(_profile) do
    gamma_inverse_companding(2.2)
  end

  defp gamma_inverse_companding(g), do: fn v -> :math.pow(v, g) end
end
