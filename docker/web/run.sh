#!/usr/bin/env bash

mix deps.get

mix event_store.create
mix event_store.init
mix ecto.create
mix ecto.setup

MIX_ENV=test mix event_store.create
MIX_ENV=test mix event_store.init
mix test

cd assets/ && yarn install && cd -

export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
iex -S mix phx.server
