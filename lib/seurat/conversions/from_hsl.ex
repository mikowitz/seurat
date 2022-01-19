defprotocol Seurat.Conversions.FromHsl do
  @spec convert(Seurat.Models.Hsl.t()) :: Seurat.color()
  def convert(hsl)
end
