defprotocol Seurat.Conversions.FromRgb do
  @spec convert(Seurat.Models.Rgb.t()) :: Seurat.color()
  def convert(rgb)
end
