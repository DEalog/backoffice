#!/bin/sh

bin/backoffice eval "DealogBackoffice.Release.init_event_store()"
bin/backoffice eval "DealogBackoffice.Release.migrate()"
bin/backoffice eval "DealogBackoffice.Release.import_administrative_areas()"

bin/backoffice start
