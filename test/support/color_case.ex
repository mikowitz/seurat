defmodule Seurat.ColorCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Seurat.ColorMine
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
end
