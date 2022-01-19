defmodule Seurat do
  alias Seurat.Models.{
    Hsl,
    Hsv,
    Hwb,
    Lab,
    Luv,
    Rgb,
    Xyz,
    Yxy
  }

  @type color ::
          Hsl.t()
          | Hsv.t()
          | Hwb.t()
          | Lab.t()
          | Luv.t()
          | Rgb.t()
          | Xyz.t()
          | Yxy.t()

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
