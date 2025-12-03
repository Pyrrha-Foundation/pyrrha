# Multistage docker build, requires docker 17.05

# builder stage
FROM ubuntu:20.04 AS builder

RUN set -ex && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        pkg-config

WORKDIR /src
COPY . .

ARG NPROC
RUN set -ex && \
    git submodule init && git submodule update --depth 1 && \
    rm -rf build && \
    if [ -z "$NPROC" ] ; \
    then make -j$(nproc) depends target=x86_64-linux-gnu ; \
    else make -j$NPROC depends target=x86_64-linux-gnu ; \
    fi

# runtime stage
FROM ubuntu:20.04

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install ca-certificates curl && \
    apt-get clean && \
    rm -rf /var/lib/apt
COPY --from=builder /src/build/x86_64-linux-gnu/release/bin /usr/local/bin/
COPY utils/seed-entrypoint.sh /usr/local/bin/seed-entrypoint.sh
RUN chmod +x /usr/local/bin/seed-entrypoint.sh

# Create pyrrha user
RUN adduser --system --group --disabled-password pyrrha && \
        mkdir -p /wallet /home/pyrrha/.pyrrha && \
        chown -R pyrrha:pyrrha /home/pyrrha/.pyrrha && \
        chown -R pyrrha:pyrrha /wallet

# Contains the blockchain
VOLUME /home/pyrrha/.pyrrha

# Generate your wallet via accessing the container and run:
# cd /wallet
# pyrrha-wallet-cli
VOLUME /wallet

EXPOSE 21090
EXPOSE 21091
EXPOSE 21092

# switch to user pyrrha
USER pyrrha

ENTRYPOINT ["pyrrhad"]
CMD ["--p2p-bind-ip=0.0.0.0", "--p2p-bind-port=21090", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=21091", "--non-interactive", "--confirm-external-bind"]

