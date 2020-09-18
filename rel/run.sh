#!/usr/bin/env sh

bin/backoffice eval "DealogBackoffice.Release.init_event_store()"
bin/backoffice eval "DealogBackoffice.Release.migrate()"

bin/backoffice start
