# FileServer

Asset server for Serv

## Installation

See `README.md` in project root for details on installation

## Development

If you want to run the file server in isolation (without connecting to the admin node for updates) then you can just start the server as a "normal" Mix project

```bash
cd apps/file_server
mix run --no-halt
```

However, the node must be named if you want the admin and file server to communicate. You can instead start the server with

```bash
cd apps/file_server
elixir --name file-server@127.0.0.1 --no-halt -S mix run
```

In the above instance, `file-server` could be replaced with anything.

If you want to start multiple file instances, make sure to provide a `PORT` environment variable, as multiple servers cannot share the same port.
