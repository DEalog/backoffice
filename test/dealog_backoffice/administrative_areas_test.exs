defmodule DealogBackoffice.AdministrativeAreasTest do
  use DealogBackoffice.DataCase

  alias DealogBackoffice.AdministrativeAreas

  @valid_attrs %{ags: "123", name: "An area", type_label: "A type", type: "type", parent_ags: nil}

  describe "adding an administrative area" do
    test "succeeds with valid data" do
      assert {:ok, inserted_area} = AdministrativeAreas.create(@valid_attrs)
      assert inserted_area.ags == "123"
      assert inserted_area.name == "An area"
      assert inserted_area.type_label == "A type"
      assert inserted_area.type == "type"
      assert inserted_area.parent_ags == nil
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
      assert inserted_area.ags == area.ags
      assert inserted_area.name == area.name
      assert inserted_area.type_label == area.type_label
      assert inserted_area.type == area.type
      assert inserted_area.parent_ags == area.parent_ags
    end
  end

  describe "listing hierarchical filtered administrative areas" do
    test "returns empty list if nothing is there" do
      assert [] == AdministrativeAreas.list_hierarchical_by("0")
    end

    test "returns list when areas are available" do
      area = create_administrative_area()
      assert [inserted_area] = AdministrativeAreas.list_hierarchical_by("123")
      assert inserted_area.ags == area.ags
      assert inserted_area.name == area.name
      assert inserted_area.type_label == area.type_label
      assert inserted_area.type == area.type
      assert inserted_area.parent_ags == area.parent_ags
    end

    test "returns an empty list when areas are available but not matching" do
      create_administrative_area()
      assert [] == AdministrativeAreas.list_hierarchical_by("0")
    end

    test "returns a list with child ags" do
      parent_area = create_administrative_area()
      child_area = create_administrative_area(%{@valid_attrs | ags: "1231", parent_ags: "123"})
      create_administrative_area(%{@valid_attrs | ags: "1241", parent_ags: "124"})

      assert [inserted_parent_area, inserted_child_area] =
               AdministrativeAreas.list_hierarchical_by("123")

      assert inserted_parent_area.ags == parent_area.ags
      assert inserted_child_area.ags == child_area.ags
    end
  end

  defp create_administrative_area(attrs \\ @valid_attrs) do
    {:ok, area} = AdministrativeAreas.create(attrs)
    area
  end
end
