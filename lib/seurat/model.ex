defmodule Seurat.Model do
  defmacro __using__(model_category) do
    quote do
      @doc false
      def model_category, do: unquote(model_category)
    end
  end
end
