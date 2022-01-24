defprotocol Seurat.Conversions.FromLuv do
  @spec convert(Seurat.Models.Luv.t()) :: Seurat.color()
  def convert(color)
end
