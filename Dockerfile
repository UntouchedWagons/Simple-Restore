FROM debian:bookworm-slim
LABEL org.opencontainers.image.authors="untouchedwagons@fastmail.com"

COPY scripts/run.sh /root/run.sh

RUN chmod 0744 /root/run.sh

CMD ["/root/run.sh"]