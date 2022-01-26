defprotocol Seurat.Conversions.FromLchuv do
  @spec convert(Seurat.Models.Lchuv.t()) :: Seurat.color()
  def convert(lchuv)
end
