defprotocol Seurat.Conversions.FromHsluv do
  @spec convert(Seurat.Models.Hsluv.t()) :: Seurat.color()
  def convert(hsluv)
end
