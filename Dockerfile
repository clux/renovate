FROM ghcr.io/renovatebot/renovate:37-slim

# renovate: datasource=github-releases depName=clux/whyq
ARG YQ_VER=0.10.2
# renovate: datasource=github-releases depName=casey/just
ARG JUST_VER=1.28.0
# renovate: datasource=github-releases depName=BurntSushi/ripgrep
ARG RG_VER=14.1.0
# renovate: datasource=github-releases depName=sharkdp/fd
ARG FD_VER=10.2.0
# renovate: datasource=github-releases depName=chmln/sd
ARG SD_VER=1.0.0
# renovate: datasource=github-releases depName=protocolbuffers/protobuf
ARG PB_VER=28.2

USER root
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal -y && rustup component add rustfmt
RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PB_VER}/protoc-${PB_VER}-linux-x86_64.zip -o /tmp/protoc.zip && \
      unzip /tmp/protoc.zip 'bin/*' -d /usr/local/
RUN curl -sSL https://github.com/clux/whyq/releases/download/${YQ_VER}/yq-x86_64-unknown-linux-musl.tar.xz | tar xJ --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/casey/just/releases/download/${JUST_VER}/just-${JUST_VER}-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin && \
    curl -sSL https://github.com/BurntSushi/ripgrep/releases/download/${RG_VER}/ripgrep-${RG_VER}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/sharkdp/fd/releases/download/v${FD_VER}/fd-v${FD_VER}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*fd' && \
    curl -sSL https://github.com/chmln/sd/releases/download/v${SD_VER}/sd-v${SD_VER}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*sd'

RUN rg --version && which rg && \
    sd --version && which fd && \
    just --version && which just && \
    sd --version && which sd && \
    yq --version && which yq && \
    protoc --version && which protoc && \
    cargo --version && which cargo && \
    rustc --version && which rustc && \
    cargo fmt --version && which rustfmt

USER ubuntu
