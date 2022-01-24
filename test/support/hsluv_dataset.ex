defmodule Seurat.HsluvDataset do
  @raw_data "test/support/hsluv_dataset.json"
            |> File.read!()
            |> Jason.decode!()
            |> Enum.map(fn {hex, v} ->
              %{
                color: hex,
                xyz: apply(Seurat.Models.Xyz, :new, v["xyz"]),
                luv: apply(Seurat.Models.Luv, :new, v["luv"]),
                rgb: apply(Seurat.Models.Rgb, :new, v["rgb"])
              }
            end)

  def data, do: @raw_data
end
