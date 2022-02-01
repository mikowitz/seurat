defmodule Seurat do
  @moduledoc """

  ## Conversions

  <div class="mermaid">
  #{File.read!("priv/mermaid.html")}
  </div>
  """
  alias Seurat.Models.{
    Hsl,
    Hsluv,
    Hsv,
    Hwb,
    Lab,
    Lch,
    Lchuv,
    Luv,
    Rgb,
    Xyz,
    Yxy
  }

  @type color ::
          Hsl.t()
          | Hsluv.t()
          | Hsv.t()
          | Hwb.t()
          | Lab.t()
          | Lch.t()
          | Lchuv.t()
          | Luv.t()
          | Rgb.t()
          | Xyz.t()
          | Yxy.t()

  @type illuminant ::
          :a
          | :b
          | :c
          | :d50
          | :d55
          | :d65
          | :d75
          | :e
          | :f2
          | :f7
          | :f11
          | :d50_10degree
          | :d55_10degree
          | :d65_10degree
          | :d75_10degree

  @type rgb_profile ::
          :adobe
          | :pro_photo
          | :srgb
          | :wide_gamut

  @spec to(color(), atom) :: color
  def to(color, target_colorspace) do
    Module.concat(
      conversion_protocol(color.__struct__),
      target_colorspace
    ).convert(color)
  end

  defp conversion_protocol(source_colorspace) do
    from = source_colorspace |> Module.split() |> List.last()
    Module.concat(Seurat.Conversions, :"From#{from}")
  end
end
