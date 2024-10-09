# This Dockerfile:
# * Simply bundles an application built on the host machine
# * Requires external dependencies to be installed by CI
# * Does not ensure the build and run OS architectures are the same; this must be orchestrated by CI
FROM ubuntu:latest
ARG application={{ project-name }}
ARG profile=release
ARG architecture
WORKDIR /app
# If a binary has been built for the default architecuture, try using that first
COPY ./target/${profile}/${application} /app/${application}
# If an architecture-spcecific binary has been built, prefer that
COPY ./target/${architecture}/${profile}/${application} /app/${application}
ENTRYPOINT ["/app/${application}"]
