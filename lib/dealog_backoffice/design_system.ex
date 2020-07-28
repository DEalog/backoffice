defmodule DealogBackoffice.DesignSystem do
  @color_sorting_order [
    "single",
    "gray",
    "orange",
    "red",
    "yellow",
    "green",
    "teal",
    "blue",
    "indigo",
    "purple",
    "pink"
  ]

  def list_colors do
    color_config =
      File.stream!(Path.join(:code.priv_dir(:dealog_backoffice), "static/tailwind.json"))
      |> Enum.to_list()
      |> Jason.decode!()
      |> Map.fetch!("theme")
      |> Map.fetch!("colors")

    Enum.map(@color_sorting_order, fn color ->
      case color do
        "single" ->
          {color, extract_single_colors(color_config)}

        _ ->
          {color, Map.fetch!(color_config, color)}
      end
    end)
  end

  defp extract_single_colors(color_config) do
    Enum.filter(color_config, fn {name, val} ->
      !is_map(val) && val != "transparent" && name != "current"
    end)
    |> Enum.reduce(%{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
  end
end
