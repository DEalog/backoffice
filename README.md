# DEalog Backoffice

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

## Used technologies

The DEalog Backoffice application uses the following (main) technologies:

- [Elixir](https://elixir-lang.org)
- [Phoenix Framework](https://phoenixframework.org)
- [TailwindCSS](https://tailwindcss.com)
- [Alpine.js](https://github.com/alpinejs/alpine)
- [Postgres](https://www.postgresql.org)

## Technical decisions

As the DEalog platform transports important information and it is important to
know what happened when by whom event sourcing is implemented which serves as
an audit log as well as a reproducible state of data.

To get a snappy UI feeling the project leverages
[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html).
