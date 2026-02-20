FROM ubuntu:24.04

ARG USERNAME=ubuntu
ARG NODE_MAJOR=22

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    fd-find \
    git \
    gnupg \
    jq \
    less \
    libssl-dev \
    openssh-client \
    pkg-config \
    ripgrep \
    sudo \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
      > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g opencode-ai \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/*

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then useradd --create-home --shell /bin/bash ${USERNAME}; fi \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN su - ${USERNAME} -c 'curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal' \
    && su - ${USERNAME} -c 'curl -fsSL https://bun.sh/install | bash'

ENV PATH="/home/${USERNAME}/.cargo/bin:/home/${USERNAME}/.bun/bin:${PATH}"

WORKDIR /workspace
USER ${USERNAME}

CMD ["sleep", "infinity"]
