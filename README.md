# DEalog Backoffice

![Elixir CI](https://github.com/DEalog/backoffice/workflows/Elixir/badge.svg)
![Deployment](https://github.com/DEalog/backoffice/workflows/Deployment/badge.svg)

The DEalog Backoffice is the authoring part of the DEalog platform, a platform
for official communication in cases of emergency.

For more information please see [the DEalog website](https://dealog.info).

## Development

The following section describes the development setup with all needed
prerequisites needed to get the application up and running locally.

### Requirements

- [Mutagen](https://mutagen.io) for code syncing
- [Docker](https://docker.io) for running the code
- Editor for coding

> Mutagen is mainly used to speed up file sync especially on macOS.

### Getting up and running

In order to get the stack booted just run `./dev start`. This will check if above
mentioned tools are available and accessible then start the stack.

> To get all available commands of the `dev` script run `./dev --help`.

### Testing

To run the tests please use `./dev test` or `./dev test.watch`.

> Functional tests are ran in the `en` locale whereas the default locale for the
> app is `de`.

### Translations

The DEalog Backoffice strings are all in english language. These are translated
to German. To quickly get the `po` files updated run `./dev translations.update`.
After that you can easily fill in the translations. If not sure about the
wording let it be resolved during the pull request process.

### Replaying projections

The DEalog Backoffice uses the [Commanded](https://commanded.io) library
providing [CQRS](https://www.martinfowler.com/bliki/CQRS.html) support. To
replay projections use the following script:

`./dev mix run priv/repo/reset_projection.exs`

On the remote machine you can use this script as well but have to add the
`--run` option.

## Collaboration

If you want to collaborate please follow this guide:

- Fork the repository
- Implement the feature, change or bugfix
- Add tests where it makes sense
- Update the [CHANGELOG.md](CHANGELOG.md)
- Update the translations (see translation section)
- Create a pull request against the original repository

## Building a release

The DEalog Backoffice can be deployed as a Docker container. The following
steps are needed to have a deployable version.

### Building the image

To build the image run

```
docker build -t dealog/backoffice:latest .
```

This will prepare and build the image that then can be used to spawn a
running container.

The following environment variables need to be set (and respective service need
to be reachable):

- `DATABASE_URL`: The content / projection database. (f.e.: `ecto://postgres:postgres@db/bo_db_prod`)
- `EVENT_STORE_DATABASE_URL`: The database for the event store. (e.g. `ecto://postgres:postgres@db/bo_es_db_prod`)
- `SECRET_KEY_BASE`: The Phoenix secret. (generate via `mix phx.gen.secret`)
- `HOSTNAME`: The hostname needed for WebSockets. (f.e. `localhost`)

> To test this locally it is recommended to start up a PostgreSQL instance being
> accessible from the Backoffice Docker container and use a `.env` file for the
> variables mentioned above.

### Setup the event store

To initialize the event store the following command needs to be run:

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/testing eval "DealogBackoffice.Release.init_event_store()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from.

### Running migrations

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/testing eval "DealogBackoffice.Release.migrate()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from.

### Start the container

```
docker run -p 5000:5000 --network my_network --env-file=./.env dealog/backoffice:latest
```

When started on locahost the DEalog Backoffice is reachable via
`http://localhost:5000`.

## Used technologies

The DEalog Backoffice application uses the following (main) technologies,
frameworks and libraries:

- [Elixir](https://elixir-lang.org)
- [Phoenix Framework](https://phoenixframework.org)
- [Commanded](https://commanded.io)
- [TailwindCSS](https://tailwindcss.com)
- [Alpine.js](https://github.com/alpinejs/alpine)
- [Postgres](https://www.postgresql.org)

## Technical decisions

As the DEalog platform transports important information and it is important to
know what happened when by whom event sourcing is implemented which serves as
an audit log as well as a reproducible state of projected data.

To get a snappy UI feeling the project leverages
[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html).
