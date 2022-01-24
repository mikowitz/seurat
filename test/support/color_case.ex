defmodule Seurat.ColorCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Seurat.ColorMine
      alias Seurat.HsluvDataset
      import Seurat.ColorCase
    end
  end

  def assert_colors_equal(expected, actual, color_name, epsilon \\ 0.05)

  def assert_colors_equal(
        %{__struct__: s} = expected,
        %{__struct__: s} = actual,
        color_name,
        epsilon
      ) do
    fields = Map.keys(expected) -- [:__struct__]

    for field <- fields do
      assert_in_delta Map.get(expected, field),
                      Map.get(actual, field),
                      epsilon,
                      "expected #{color_name} to be #{inspect(expected)}, got #{inspect(actual)}"
    end
  end

  def assert_colors_equal(%{__struct__: e}, %{__struct__: a}, _, _) do
    raise "Expected matching color types, got #{e} and #{a}"
  end

  def assert_colors_equal(x, y, _, _) do
    raise "Expected matching color types, got #{inspect(x)} and #{inspect(y)}"
  end

  def test_conversion(dataset, expected_key, source_key, to_model, epsilon \\ 0.05) do
    dataset.data()
    |> Enum.map(fn color_data ->
      Task.async(fn ->
        expected = Map.get(color_data, expected_key)
        actual = Seurat.to(Map.get(color_data, source_key), to_model)

        assert_colors_equal(expected, actual, Map.get(color_data, :color), epsilon)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end
end
