defmodule DealogBackoffice.AdministrativeAreas.AdministrativeArea do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:ars, :string, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "administrative_areas" do
    field :parent_ars, :string
    field :name, :string
    field :type_label, :string
    field :type, :string
    field :imported_at, :naive_datetime_usec

    has_many :children, __MODULE__, foreign_key: :parent_ars, references: :ars
  end

  @doc false
  def changeset(area, params) do
    area
    |> cast(params, [:ars, :parent_ars, :name, :type_label, :type, :imported_at])
    |> validate_required([:ars, :name, :type_label, :type])
    |> unique_constraint(:ars)
  end
end
