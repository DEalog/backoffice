FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.14.0 AS build

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/yarn.lock ./assets/
RUN npm install -g yarn && cd assets && yarn install

COPY priv priv
COPY assets assets
COPY lib lib

RUN cd assets && yarn deploy && yarn dump
RUN mix phx.digest

# compile and build release
COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.17.0 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

COPY CHANGELOG.md /app/CHANGELOG.md
COPY README.md /app/README.md
COPY rel/run.sh /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/backoffice ./

ENV HOME=/app

CMD ["./run.sh"]
