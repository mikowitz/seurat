defmodule Seurat.MixProject do
  use Mix.Project

  def project do
    [
      app: :seurat,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      elixirc_paths: compiler_paths(Mix.env()),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.2"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:nimble_csv, "~> 1.1", only: [:dev, :test]}
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      plt_add_apps: [:ex_unit]
    ]
  end

  defp compiler_paths(:test), do: ["test/support"] ++ compiler_paths(:prod)
  defp compiler_paths(:dev), do: compiler_paths(:test)
  defp compiler_paths(_), do: ["lib"]

  defp docs do
    [
      main: Seurat,
      groups_for_modules: [
        "Color Models": [
          Seurat.Models.Hsl,
          Seurat.Models.Hsv,
          Seurat.Models.Hwb,
          Seurat.Models.Lab,
          Seurat.Models.Lch,
          Seurat.Models.Luv,
          Seurat.Models.Lchuv,
          Seurat.Models.Rgb,
          Seurat.Models.Yxy,
          Seurat.Models.Xyz
        ],
        Conversions: [
          Seurat.Conversions.FromHsl,
          Seurat.Conversions.FromHsv,
          Seurat.Conversions.FromHwb,
          Seurat.Conversions.FromLab,
          Seurat.Conversions.FromLch,
          Seurat.Conversions.FromLuv,
          Seurat.Conversions.FromLchuv,
          Seurat.Conversions.FromRgb,
          Seurat.Conversions.FromYxy,
          Seurat.Conversions.FromXyz
        ],
        Utilities: [
          Seurat.Inspect,
          Seurat.Model
        ]
      ],
      before_closing_body_tag: fn
        :html ->
          """
          <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"</script>
          <script>mermaid.initialize({startOnLoad: true})</script>
          """

        _ ->
          ""
      end
    ]
  end
end
