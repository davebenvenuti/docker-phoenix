FROM elixir:1.12.1 as base

RUN apt-get update && apt-get -y upgrade && apt-get install -y inotify-tools

RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /app

RUN useradd -ms /bin/bash app

RUN chown -R app /app

USER app

WORKDIR /app

RUN mix local.hex --force

RUN mix archive.install hex phx_new 1.5.9 --force

FROM base

COPY mix.exs /app

RUN mix local.rebar --force && mix deps.get && mix deps.compile

CMD ["mix", "phx.server"]