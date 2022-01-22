defprotocol Seurat.Conversions.FromYxy do
  @spec convert(Seurat.Models.Yxy.t()) :: Seurat.color()
  def convert(color)
end
