defprotocol Seurat.Conversions.FromHwb do
  @spec convert(Seurat.Models.Hwb.t()) :: Seurat.color()
  def convert(color)
end
