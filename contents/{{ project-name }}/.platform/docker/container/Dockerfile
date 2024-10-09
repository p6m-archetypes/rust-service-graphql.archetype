# This Dockerfile:
# * Builds the application in a container
# * Ensures the build architecture is the same as the container architecutre
# * Does not require that the host machine have OS dependencies installed locally
FROM lukemathwalker/cargo-chef:latest-rust-1.75.0 AS chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
ARG application={{ project-name }}
ARG profile=release
ARG architecture=aarch64-unknown-linux-gnu
RUN echo Profile: ${profile}
RUN rustup component add rustfmt
RUN rustup target add aarch64-unknown-linux-gnu
COPY --from=planner /app/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN if [ "${profile}" = "release" ]; then \
  cargo chef cook --release --recipe-path recipe.json; \
else \
  cargo chef cook --recipe-path recipe.json; \
fi
# Build application
COPY . .
RUN if [ "${profile}" = "release" ]; then \
  cargo build --release --bin ${application} --target ${architecture}; \
else \
  cargo build --bin ${application} --target ${architecture}; \
fi

# We do not need the Rust toolchain to run the binary!
FROM ubuntu:latest
ARG application={{ project-name }}
ARG profile=release
ARG architecture=aarch64-unknown-linux-gnu
RUN echo Profile: ${profile}
WORKDIR /app
COPY --from=builder /app/target/${architecture}/${profile}/${application} /app/${application}
ENTRYPOINT ["/app/${application}"]
