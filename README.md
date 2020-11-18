# DEalog Backoffice

![Elixir CI](https://github.com/DEalog/backoffice/workflows/Elixir/badge.svg)
![Build](https://github.com/DEalog/backoffice/workflows/Build/badge.svg)
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

### Create a super user

To create a super user for local development please run

```
./dev mix run priv/repo/create_super_user.exs
```

If successful you will see an output like this:

`Confirmed super user created: %{email: "super_user@dealog.de", password: "C7LX6OQsULON"}`

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

To build the image run:

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
- `PROJECTORS` (optional): The projectors that should be active. Can either be `all` (default) or `local`.
- `KAFKA_HOSTS`: The Kafka host(s). (e.g. `localhost:9092`); Can be an empty string if `local` is used.
- `SMTP_RELAY`: The SMTP relay address. (f.e. `mail.domain.tld`)
- `SMTP_PORT`: The SMTP server port. (e.g. `587`)
- `SMTP_USERNAME`: The username for the SMTP server.
- `SMTP_PASSWORD`: The password for the SMTP server.

> To test this locally it is recommended to start up a PostgreSQL instance being
> accessible from the Backoffice Docker container and use a `.env` file for the
> variables mentioned above.

The following environment variables can be set:

- `SUPER_USER_EMAIL`: The email address of the super user to create.
- `SUPER_USER_PASSWORD`: The password for the super user to be set.

> If these variables are not set everything will work fine just some
> functionality will not be executed.

### Deployment all in one

For now there is a command script under `rel/run.sh` running all the setup
and migration commands on container start to ease the initial deployment.

For this to work start the container like this:

```
docker run -it -p 5000:4000 --network my_network --env-file=./.env dealog/backoffice:latest
```

> Note: You need to pass the `-it` flag to capture a `ctrl-c` interupt. If not
> passed you'd need to kill the running container.

### Setup the event store

To initialize the event store the following command needs to be run:

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/backoffice eval "DealogBackoffice.Release.init_event_store()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from.

### Running migrations

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/backoffice eval "DealogBackoffice.Release.migrate()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from.

### Import the adminsitrative areas

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/backoffice eval "DealogBackoffice.Release.import_administrative_areas()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from.

### Create the super user

```
docker run --network my_network --env-file=./.env dealog/backoffice:latest bin/backoffice eval "DealogBackoffice.Release.create_super_user()"
```

> Note: `my_network` should contain the network the PostgreSQL instance is
> reachable from. Further ensure that the `SUPER_USER_EMAIL` and
> `SUPER_USER_PASSWORD` env vars are set.

### Start the container

```
docker run -p 5000:4000 --network my_network --env-file=./.env dealog/backoffice:latest
```

When started on locahost the DEalog Backoffice is reachable via
`http://localhost:5000`.

## Preview deployment

In order to deploy a branch for review there is a script available. The script
creates a Dokku application and deploys the current branch.

Currently this is a manual task.

> Please copy the `preview_env.dist` to `.preview_env` and set the variables
> accordingly:
> `cp preview_env.dist .preview_env`

To deploy run: `./preview_deploy` on the respective branch.
To cleanup run: `./preview_deploy --cleanup` on the branch. Additionally you
can pass a sanitized branch name as second argument to remove a different
deployment.

> You need to have access to the Dev server instance to deploy.

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

Mailing is done via the great [Swoosh](https://hexdocs.pm/swoosh/Swoosh.html) library.
