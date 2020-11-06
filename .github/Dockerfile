FROM alpine:3.11

RUN set -xe \
    && apk add --no-cache \
        openssl \
        ncurses-libs

WORKDIR /app

COPY ./CHANGELOG.md ./CHANGELOG.md
COPY --chown=nobody:nobody ./rel/run.sh .
COPY --chown=nobody:nobody ./_build/prod/rel/backoffice .

RUN set -xe \
    && mkdir ./tmp \
    && chown -R nobody:nobody ./tmp

USER nobody:nobody

CMD ["./run.sh"]