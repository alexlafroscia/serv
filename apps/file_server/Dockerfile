# base image elixer to start with
FROM elixir:1.5.1

# install hex package manager
RUN mix local.hex --force

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# setting the port and the environment (prod = PRODUCTION!)
ENV MIX_ENV=prod
ENV PORT=4000

# install dependencies (production only)
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

WORKDIR apps/file_server

ENTRYPOINT ["mix"]
CMD ["run", "--no-halt"]
