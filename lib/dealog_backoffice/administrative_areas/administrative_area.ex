defmodule DealogBackoffice.AdministrativeAreas.AdministrativeArea do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:ags, :string, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "administrative_areas" do
    field :parent_ags, :string
    field :name, :string
    field :type_label, :string
    field :type, :string

    has_many :children, __MODULE__, foreign_key: :parent_ags, references: :ags

    timestamps()
  end

  @doc false
  def changeset(area, params) do
    area
    |> cast(params, [:ags, :parent_ags, :name, :type_label, :type])
    |> validate_required([:ags, :name, :type_label, :type])
    |> unique_constraint(:ags)
  end
end
