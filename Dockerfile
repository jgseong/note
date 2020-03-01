FROM alpine:3.11

RUN apk add --no-cache python python-dev py-pip build-base openssh git-fast-import
RUN pip install virtualenv
RUN pip install mkdocs
RUN rm -rf /var/cache/apk/*

RUN mkdir ~/docs

ARG USER
RUN adduser -D ${USER}

USER ${USER}
COPY config /home/${USER}/.ssh/config
COPY priv.key /home/${USER}/.ssh/priv.key

USER root
RUN chmod 0400 /home/${USER}/.ssh/config
RUN chmod 0400 /home/${USER}/.ssh/priv.key

USER ${USER}
WORKDIR /home/${USER}/docs

CMD ["mkdocs", "serve"]
