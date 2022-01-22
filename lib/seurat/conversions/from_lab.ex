defprotocol Seurat.Conversions.FromLab do
  @spec convert(Seurat.Models.Lab.t()) :: Seurat.color()
  def convert(color)
end
