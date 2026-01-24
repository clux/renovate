FROM renovate/renovate:42.92.4

# renovate: datasource=github-releases depName=clux/lq
ARG LQ_VERSION=0.15.0
# renovate: datasource=github-releases depName=casey/just
ARG JUST_VERSION=1.46.0
# renovate: datasource=github-releases depName=BurntSushi/ripgrep
ARG RG_VERSION=15.1.0
# renovate: datasource=github-releases depName=sharkdp/fd
ARG FD_VERSION=10.3.0
# renovate: datasource=github-releases depName=chmln/sd
ARG SD_VERSION=1.0.0
# renovate: datasource=github-releases depName=protocolbuffers/protobuf versioning=semver-coerced
ARG PB_VERSION=v33.4

USER root

RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PB_VERSION#v}/protoc-${PB_VERSION#v}-linux-x86_64.zip -o /tmp/protoc.zip && \
      unzip /tmp/protoc.zip 'bin/*' -d /usr/local/
RUN curl -sSL https://github.com/clux/lq/releases/download/${LQ_VERSION}/lq-x86_64-unknown-linux-musl.tar.xz | tar xJ --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin && \
    curl -sSL https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin && \
    curl -sSL https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*fd' && \
    curl -sSL https://github.com/chmln/sd/releases/download/v${SD_VERSION}/sd-v${SD_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components=1 -C /usr/local/bin/ --wildcards '*sd'

RUN rg --version && which rg && \
    sd --version && which fd && \
    just --version && which just && \
    sd --version && which sd && \
    lq --version && which lq && \
    protoc --version && which protoc

USER ubuntu

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal -y --no-modify-path --default-toolchain stable && $HOME/.cargo/bin/rustup component add rustfmt

ENV PATH="/home/ubuntu/.cargo/bin:${PATH}"

RUN cargo --version && which cargo && \
    rustc --version && which rustc && \
    cargo fmt --version && which rustfmt
