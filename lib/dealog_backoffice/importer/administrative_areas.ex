defmodule DealogBackoffice.Importer.AdministrativeAreas do
  @moduledoc """
  Importer for CSV based administrative areas.
  """

  alias DealogBackoffice.Repo

  @doc """
  Load administrative areas from files within path.
  """
  def import_all_from(path) do
    Repo.delete_all("administrative_areas")

    count =
      collect_import_files(path)
      |> Enum.reduce(0, fn file, total ->
        {amount, _} = import_file(path, file)
        total + amount
      end)

    IO.puts("\tInserted #{count} new administrative areas")
  end

  defp collect_import_files(path) do
    File.ls!(path)
    |> Enum.filter(&(Path.extname(&1) == ".csv"))
    |> Enum.sort()
  end

  defp import_file(path, file_name) do
    full_path = Path.join(path, file_name)
    ars = Path.rootname(file_name)
    IO.puts("\tProcessing ARS #{ars}")

    entries =
      File.stream!(full_path)
      |> CSV.decode!(strip_fields: true, headers: true)
      |> Enum.map(
        &%{
          ars: &1["ars"],
          type_label: &1["bez"],
          type: &1["type"],
          name: &1["gen"],
          parent_ars: &1["parent_ars"],
          imported_at: NaiveDateTime.utc_now()
        }
      )

    Repo.insert_all("administrative_areas", entries, on_conflict: :nothing)
  end
end
