defmodule Seurat.HsluvDataset do
  @moduledoc false

  @raw_data "test/support/hsluv_dataset.json"
            |> File.read!()
            |> Jason.decode!()
            |> Enum.map(fn {hex, v} ->
              %{
                color: hex,
                xyz: apply(Seurat.Models.Xyz, :new, v["xyz"]),
                luv: apply(Seurat.Models.Luv, :new, v["luv"]),
                rgb: apply(Seurat.Models.Rgb, :new, v["rgb"]),
                lchuv: apply(Seurat.Models.Lchuv, :new, v["lch"]),
                hsluv: apply(Seurat.Models.Hsluv, :new, v["hsluv"])
              }
            end)

  def data, do: @raw_data
end
