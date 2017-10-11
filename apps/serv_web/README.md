# ServWeb

Admin UI and API server for Serv

## Installation

See `README.md` in project root for details on installation

## Development

If you want to run the API srever in isolation (without the file server connecting to it for updates) then you can run it like a regular Phoenix app:

```bash
cd apps/serv_web
mix phx.server
```

However, if you want file server nodes to connect to the admin, then it should be started locally like so:

```bash
cd apps/serv_web
elixir --name api-server@127.0.0.1 -S mix phx.server
```

The file server nodes will automatically discover it and connect. The admin node uses the list of connected nodes to broadcast information such as cache invalidation queues.
