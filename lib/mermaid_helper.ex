defmodule Seurat.MermaidHelper do
  @moduledoc false

  def to_file do
    File.open("priv/mermaid.html", [:write], fn file ->
      IO.write(file, "flowchart TB;\n")
      IO.write(file, get_conversions())
      IO.write(file, "\n")
      IO.write(file, get_colorspaces())
      IO.write(file, "\n")
    end)
  end

  @doc """
  Build a list of colorspace conversions and format them for injection into
  a Mermaid-formatted block of connections in the main `Seurat` module docs
  """
  def get_conversions do
    modules()
    |> Enum.filter(fn m ->
      m = Module.split(m)
      length(m) == 6 and Enum.take(m, 2) == ~w(Seurat Conversions)
    end)
    |> Enum.map(fn m ->
      [_, _, from, _, _, to] = Module.split(m)
      from = String.replace(from, "From", "")
      {from, to}
    end)
    |> Enum.reject(fn
      {c, c} -> true
      _ -> false
    end)
    |> Enum.group_by(fn {a, b} -> Enum.sort([a, b]) end)
    |> Enum.map(fn {_, v} ->
      case v do
        [{a, b}, {b, a}] -> "#{a}<-->#{b};"
        [{a, b}] -> "#{a}-->#{b};"
      end
    end)
    |> Enum.join("\n")
  end

  def get_colorspaces do
    modules()
    |> Enum.filter(fn m ->
      m = Module.split(m)
      length(m) == 6 and Enum.take(m, 2) == ~w(Seurat Models)
    end)
    |> Enum.map(fn m ->
      {
        m |> Module.split() |> List.last(),
        m.model_category()
      }
    end)
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.with_index()
    |> Enum.map(fn {{k, vs}, i} ->
      [
        "subgraph id#{i} [#{k}];",
        Enum.map(vs, &"#{elem(&1, 0)};"),
        "end;"
      ]
      |> List.flatten()
      |> Enum.join("\n")
    end)
    |> Enum.join("\n")
  end

  defp modules do
    with {:ok, list} <- :application.get_key(:seurat, :modules), do: list
  end
end
