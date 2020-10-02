alias DealogBackoffice.Importer.AdministrativeAreas

path = Path.expand(__DIR__ <> "/administrative_areas")

IO.puts("Importing administrative areas from #{path}")

amount = AdministrativeAreas.import_all_from(path)

IO.puts("Imported #{amount} new administrative areas")
