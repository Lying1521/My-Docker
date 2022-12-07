FROM bitnami/rabbitmq:3.9.18-debian-10-r0

MAINTAINER liyu

USER 601

COPY rabbitmq-cluster /usr/local/bin/
COPY --chown=601:0 .erlang.cookie /var/lib/rabbitmq/.erlang.cookie
RUN chmod 600 /var/lib/rabbitmq/.erlang.cookie

EXPOSE 5672 15672 25672 4369 9100 9101 9102 9103 9104 9105


CMD ["rabbitmq-cluster"]