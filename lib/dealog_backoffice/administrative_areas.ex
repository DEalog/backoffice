defmodule DealogBackoffice.AdministrativeAreas do
  @moduledoc """
  Functions for handling administrative areas.
  """

  import Ecto.Query, warn: false

  alias DealogBackoffice.Repo
  alias DealogBackoffice.AdministrativeAreas.AdministrativeArea

  def list do
    AdministrativeArea
    |> preload()
    |> Repo.all()
  end

  def create(attrs) do
    %AdministrativeArea{}
    |> AdministrativeArea.changeset(attrs)
    |> Repo.insert()
  end

  defp preload(area_or_areas) do
    from a in area_or_areas,
      preload: [:children]
  end
end
