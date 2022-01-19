defprotocol Seurat.Conversions.FromHsv do
  @spec convert(Seurat.Models.Hsv.t()) :: Seurat.color()
  def convert(hsv)
end
