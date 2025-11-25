ARG BASE_IMAGE=registry.fedoraproject.org/fedora
ARG BASE_VERSION=43
ARG IMAGE=${BASE_IMAGE}:${BASE_VERSION}
FROM ${IMAGE} AS builder
# install dependencies (do this first for good layering)
RUN dnf install -y @c-development meson ninja yaml-cpp yaml-cpp-devel
RUN --mount=type=bind,target=/work,rw --mount=type=tmpfs,target=/bitbucket <<EOF
cd /work
make clean
mkdir /out
make BIN=/out/usr/bin/interception_vimproved PATH_DIR=/bitbucket CONFIG_DIR=/out/usr/lib/interception-vimproved install
#cp -R build/. /out
EOF
FROM scratch
COPY --from=builder /out/ /
