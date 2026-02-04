# Devcontainer Dockerfile - reproducible development image
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV TZ=Etc/UTC

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       wget \
       gnupg \
       lsb-release \
       build-essential \
       git \
       sudo \
       unzip \
       locales \
       python3 \
       python3-venv \
       python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to match host UID/GID for file permission parity
RUN groupadd --gid ${USER_GID} ${USERNAME} || true \
    && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} || true \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Install a pinned Node.js LTS (18.x) from NodeSource for reproducibility
RUN set -eux; \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs npm; \
    rm -rf /var/lib/apt/lists/*; \
    # ensure npm is available
    if ! command -v npm >/dev/null 2>&1; then echo "npm missing" && exit 1; fi

# Install common global npm tools (pinned versions)
RUN npm install -g npm@9.8.0 yarn@1.22.19 || true

# Clean up
RUN apt-get clean || true

USER ${USERNAME}
WORKDIR /home/${USERNAME}/workspace

# Add a simple healthcheck file so the container is usable immediately
RUN mkdir -p /home/${USERNAME}/workspace

ENV PATH="$PATH:/home/${USERNAME}/.local/bin"

CMD ["bash"]
