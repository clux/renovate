FROM ghcr.io/renovatebot/renovate:37.440.7-slim

# renovate: datasource=github-releases depName=clux/whyq
ARG YQ_VERSION=0.10.2
# renovate: datasource=github-releases depName=casey/just
ARG JUST_VERSION=1.36.0
# renovate: datasource=github-releases depName=BurntSushi/ripgrep
ARG RG_VERSION=14.1.1
# renovate: datasource=github-releases depName=sharkdp/fd
ARG FD_VERSION=10.2.0
# renovate: datasource=github-releases depName=chmln/sd
ARG SD_VERSION=1.0.0
# renovate: datasource=github-releases depName=protocolbuffers/protobuf
ARG PB_VERSION=28.3

USER root

RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PB_VERSION}/protoc-${PB_VERSION}-linux-x86_64.zip -o /tmp/protoc.zip && \
      unzip /tmp/protoc.zip 'bin/*' -d /usr/local/
RUN curl -sSL https://github.com/clux/whyq/releases/download/${YQ_VERSION}/yq-x86_64-unknown-linux-musl.tar.xz | tar xJ --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin && \
    curl -sSL https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*fd' && \
    curl -sSL https://github.com/chmln/sd/releases/download/v${SD_VERSION}/sd-v${SD_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*sd'

RUN rg --version && which rg && \
    sd --version && which fd && \
    just --version && which just && \
    sd --version && which sd && \
    yq --version && which yq && \
    protoc --version && which protoc

USER ubuntu

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal -y --no-modify-path --default-toolchain stable && rustup component add rustfmt

RUN cargo --version && which cargo && \
    rustc --version && which rustc && \
    cargo fmt --version && which rustfmt
