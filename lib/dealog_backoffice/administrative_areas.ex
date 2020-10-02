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
    |> order_by([:ags])
    |> Repo.all()
  end

  @doc """
  List administrative areas by ags downwards.
  """
  def list_hierarchical_by(ags) do
    like_ags = "#{ags}%"

    from(a in AdministrativeArea,
      where: a.ags == ^ags,
      or_where: like(a.ags, ^like_ags),
      order_by: a.ags
    )
    |> preload()
    |> Repo.all()
  end

  @doc """
  Create a new administrative area.

  The following attributes can be passed:

  - `ags` The unique AGS
  - `parent_ags` The optional parent AGS
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
