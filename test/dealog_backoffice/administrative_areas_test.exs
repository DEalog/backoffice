defmodule DealogBackoffice.AdministrativeAreasTest do
  use DealogBackoffice.DataCase

  alias DealogBackoffice.AdministrativeAreas

  @valid_attrs %{
    ars: "123",
    name: "An area",
    type_label: "A type",
    type: "type",
    parent_ars: nil,
    imported_at: NaiveDateTime.utc_now()
  }

  describe "adding an administrative area" do
    test "succeeds with valid data" do
      assert {:ok, inserted_area} = AdministrativeAreas.create(@valid_attrs)
      assert inserted_area.ars == "123"
      assert inserted_area.name == "An area"
      assert inserted_area.type_label == "A type"
      assert inserted_area.type == "type"
      assert inserted_area.parent_ars == nil
    end

    test "fails when data is invalid" do
      assert {:error, _} = AdministrativeAreas.create(%{})
    end
  end

  describe "listing all administrative areas" do
    test "returns empty list if nothing is there" do
      assert [] == AdministrativeAreas.list()
    end

    test "returns list when available" do
      area = create_administrative_area()
      assert [inserted_area] = AdministrativeAreas.list()
      assert inserted_area.ars == area.ars
      assert inserted_area.name == area.name
      assert inserted_area.type_label == area.type_label
      assert inserted_area.type == area.type
      assert inserted_area.parent_ars == area.parent_ars
    end
  end

  describe "listing hierarchical filtered administrative areas" do
    test "returns empty list if nothing is there" do
      assert [] == AdministrativeAreas.list_hierarchical_by("0")
    end

    test "returns list when areas are available" do
      area = create_administrative_area()
      assert [inserted_area] = AdministrativeAreas.list_hierarchical_by("123")
      assert inserted_area.ars == area.ars
      assert inserted_area.name == area.name
      assert inserted_area.type_label == area.type_label
      assert inserted_area.type == area.type
      assert inserted_area.parent_ars == area.parent_ars
    end

    test "returns an empty list when areas are available but not matching" do
      create_administrative_area()
      assert [] == AdministrativeAreas.list_hierarchical_by("0")
    end

    test "returns a list with child ARS" do
      parent_area = create_administrative_area()
      child_area = create_administrative_area(%{@valid_attrs | ars: "1231", parent_ars: "123"})
      create_administrative_area(%{@valid_attrs | ars: "1241", parent_ars: "124"})

      assert [inserted_parent_area, inserted_child_area] =
               AdministrativeAreas.list_hierarchical_by("123")

      assert inserted_parent_area.ars == parent_area.ars
      assert inserted_child_area.ars == child_area.ars
    end
  end

  defp create_administrative_area(attrs \\ @valid_attrs) do
    {:ok, area} = AdministrativeAreas.create(attrs)
    area
  end
end
