FROM golang:1.19 AS build

WORKDIR /workspace
ENV GO111MODULE=on
ENV TEST_ASSET_PATH /_out/kubebuilder/bin

RUN apt update -qq && apt install -qq -y git bash curl g++

# Fetch binary early because to allow more caching
COPY scripts scripts
COPY testdata testdata
RUN ./scripts/fetch-test-binaries.sh

COPY src src

# Build
RUN cd src; go mod download

RUN cd src; CGO_ENABLED=0 go build -o webhook -ldflags '-w -extldflags "-static"' .

#Test
ARG TEST_ZONE_NAME
RUN  \
  if [ -n "$TEST_ZONE_NAME" ]; then \
  cd src; \
  CCGO_ENABLED=0 \
  TEST_ASSET_ETCD=${TEST_ASSET_PATH}/etcd \
  TEST_ASSET_KUBE_APISERVER=${TEST_ASSET_PATH}/kube-apiserver \
  TEST_ZONE_NAME="$TEST_ZONE_NAME" \
  go test -v .; \
  fi

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=build /workspace/src/webhook /app/webhook
USER nonroot:nonroot

ENTRYPOINT ["/app/webhook"]

LABEL org.opencontainers.image.source https://github.com/k8s-at-home/dnsmadeeasy-webhook
