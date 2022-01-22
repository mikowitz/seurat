defprotocol Seurat.Conversions.FromXyz do
  @spec convert(Seurat.Models.Xyz.t()) :: Seurat.color()
  def convert(color)
end
