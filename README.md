# Serv

To start your Phoenix server:

  * Install dependencies with `mix deps.get && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Local Development

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
