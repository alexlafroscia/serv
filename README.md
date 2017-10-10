# Serv

Serv is a static asset registry and server, built for speed. It is designed to ensure that files are only delivered when they are absolutely needed, but when a change is made to the configuration, the new version of the files are available immediately.

Other features include:
- Endpoint for uploading new files programmatically
- REST API for fetching file and file-instance information
- Password protection for API and upload endpoints
- Full admin UI with drag-and-drop uploading of files

## Local Development

### Installation

To fetch the code and install dependencies, you can do the following:

```bash
git clone git@gitlab.com:alexlafroscia/serv.git
cd serv
mix deps.get
```

With that complete and the database set up (see below) run:

```bash
mix ecto.create
mix ecto.migrate
```

and you should be good to go

### Running the App

See the `README.md` in `apps/file_server` and `apps/serv_web` respectively for details on starting the applications. They can be run independently, but if configured correctly they will communicate when run together.

### Database

All data is stored in a [PostgreSQL](https://www.postgresql.org) database. By default, it's expected that the database is running on `localhost` with username and password both set to `postgres`.  You can provide environment variables when running the server if you wish to override the defaults:

```txt
POSTGRES_HOST     # Alternate host name
POSTGRES_USER     # Alternate user name
POSTGRES_PASSWORD # Alternate passowrd
```

If you need to get Postgres installed on OSX, I suggest [Postgres.app](https://postgresapp.com).

## Running Tests

Tests can be run against the server using `mix test`

## Linting

Style checking if set up for both the front-end and back-end code.

The front-end code can be linted through

```sh
npm run lint
```

The back-end code can be linted through

```sh
mix credo
```

## Building Docker images

Since this repository contains two different applications, that would be run independently, there are two different `Dockerfile`s. To build a particular server, you'd run something like:

```sh
docker build -f apps/file_server/Dockerfile -t file-server:latest .
```

This allows the created image to be as small as possible, as well as allowing different commands for each of them.

As a shortcut, you can also execute `deploy/build` and `deploy/push` to build and push the images, respectively.
