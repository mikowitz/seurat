defmodule Seurat.WhitePoint do
  @moduledoc """
  Representation of a white point for a CIE standard illuminant.

  A standard illuminant represents a theoretical source of light that can be
  used for reliably comparing colors recorded under different lighting
  conditions. Each illuminant defines a white point which represents, often
  standardized in XYZ format, the tristimulus values for a target white under
  that illuminant.

  The following illuminants have been published by the International Commission
  on Illumination (often shortened to CIE after the French name "Commission
  internationale de l'éclairage)

  * A - represents domestic, tungsten-filament lighting with a color temperature
    of around 2856K.
  * B - represents noon sunlight, with a correlated color temperature of 4874K.
    (deprecated in favor of the D series of illuminants)
  * C - represents average daylight, with a correlated color temperature of
    6774K. (deprecated in favor of the D series of illuminants)
  * D50 - represents natural dalyight with a color temperature of around 5000K
  * D55 - represents natural dalyight with a color temperature of around 5500K
  * D65 - often used as the default when no white
    point or illuminant is specified, this illuminant is a daylight illuminant
    that corresponds roughly to average midday light in Western/Northen Europe.
  * D75 - represents natural dalyight with a color temperature of around 7500K
  * E - represents the equal energy radiator
  * F2 - represents a semi-broadband fluorescent lamp
  * F7 - represents a broadband fluorescent lamp
  * F11 - represents a narrowband fluorescent lamp

  """

  @spec for(Seurat.illuminant()) :: %{x: float, y: float, z: float}
  def for(:a), do: %{x: 1.0985, y: 1.0, z: 0.35585}
  def for(:b), do: %{x: 0.99072, y: 1.0, z: 0.85223}
  def for(:c), do: %{x: 0.98074, y: 1.0, z: 1.18232}
  def for(:d50), do: %{x: 0.96422, y: 1.0, z: 0.82521}
  def for(:d55), do: %{x: 0.95682, y: 1.0, z: 0.92149}
  def for(:d65), do: %{x: 0.95047, y: 1.0, z: 1.08883}
  def for(:d75), do: %{x: 0.94972, y: 1.0, z: 1.22638}
  def for(:e), do: %{x: 1.0, y: 1.0, z: 1.0}
  def for(:f2), do: %{x: 0.99186, y: 1.0, z: 0.67393}
  def for(:f7), do: %{x: 0.95041, y: 1.0, z: 1.08747}
  def for(:f11), do: %{x: 1.00962, y: 1.0, z: 0.6435}

  def for(:d50_10degree), do: %{x: 0.9672, y: 1.0, z: 0.8143}
  def for(:d55_10degree), do: %{x: 0.958, y: 1.0, z: 0.9093}
  def for(:d65_10degree), do: %{x: 0.9481, y: 1.0, z: 1.073}
  def for(:d75_10degree), do: %{x: 0.94416, y: 1.0, z: 1.2064}
end
