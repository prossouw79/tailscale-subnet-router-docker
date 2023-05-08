FROM tailscale/tailscale

RUN apk update \
    && apk upgrade \
    && apk add \
      bash \
      dos2unix

SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash

WORKDIR /app

COPY connect.sh .
RUN dos2unix connect.sh && chmod +x connect.sh

CMD ./connect.sh