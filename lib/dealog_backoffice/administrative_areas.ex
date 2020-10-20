defmodule DealogBackoffice.AdministrativeAreas do
  @moduledoc """
  Functions for handling administrative areas.
  """

  import Ecto.Query, warn: false

  alias DealogBackoffice.Repo
  alias DealogBackoffice.AdministrativeAreas.AdministrativeArea

  @doc """
  List all administrative areas.
  """
  def list do
    AdministrativeArea
    |> preload()
    |> order_by([:ars])
    |> Repo.all()
  end

  @doc """
  List administrative areas by ars downwards.
  """
  def list_hierarchical_by(ars) do
    like_ars = "#{ars}%"

    from(a in AdministrativeArea,
      where: a.ars == ^ars,
      or_where: like(a.ars, ^like_ars),
      order_by: a.ars
    )
    |> preload()
    |> Repo.all()
  end

  @doc """
  Create a new administrative area.

  The following attributes can be passed:

  - `ars` The unique ARS
  - `parent_ars` The optional parent ARS
  - `name` The name of the administrative area
  - `type_label` The label for the type of the administrative area
  - `type` The technical type of the administrative area (sta, lan, rbz, gem)
  """
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
