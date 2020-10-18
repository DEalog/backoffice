FROM alpine:3.9

ARG HOME=/app
ENV HOME ${HOME}

RUN set -xe \
    && apk add --no-cache \
        openssl \
        ncurses-libs

WORKDIR /${HOME}

RUN chown nobody:nobody /${HOME}

COPY CHANGELOG.md /${HOME}/CHANGELOG.md
COPY rel/run.sh /${HOME}
COPY --chown=nobody:nobody /${HOME}/_build/prod/rel/backoffice ./

USER nobody:nobody

CMD ["./run.sh"]