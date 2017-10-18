# base image elixer to start with
FROM elixir:1.5.1

# install hex package manager
RUN mix local.hex --force

# install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install node
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

# Install Brotli
RUN apt-get install -y cmake && \
    cd /tmp && \
    git clone https://github.com/google/brotli.git && \
    cd brotli && \
    mkdir out && \
    cd out && \
    ../configure-cmake && \
    make && \
    make install

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
RUN npm install

# Build front-end application
RUN npm run build

WORKDIR apps/serv_web/

# create the digests
RUN mix phx.digest

# run phoenix in production on PORT 4000
ENTRYPOINT ["mix"]
CMD ["phx.server"]
