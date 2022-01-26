defprotocol Seurat.Conversions.FromLch do
  @spec convert(Seurat.Models.Lch.t()) :: Seurat.color()
  def convert(lch)
end
