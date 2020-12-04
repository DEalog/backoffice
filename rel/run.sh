#!/usr/bin/env sh

bin/backoffice eval "DealogBackoffice.Release.init_event_store()"
bin/backoffice eval "DealogBackoffice.Release.migrate()"
bin/backoffice eval "DealogBackoffice.Release.import_administrative_areas()"
bin/backoffice eval "DealogBackoffice.Release.create_super_user()"
bin/backoffice eval "DealogBackoffice.Release.rebuild_messages_projections()"

bin/backoffice start
