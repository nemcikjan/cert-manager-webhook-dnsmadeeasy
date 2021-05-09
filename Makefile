
# Image URL to use all building/pushing image targets
IMG ?= dnsmadeeasy-webhook:latest

# Build manager binary
build: fmt vet
	cd src; go build -o ../bin/webhook main.go

# Download dependencies
download:
	cd src; go mod download

# Download dependencies
tidy: download
	cd src; go mod tidy

# Run tests
test: fetch_test_binaries
	echo "Testing with TEST_ZONE_NAME=${TEST_ZONE_NAME}"
	cd src; go test -v .

# Fetch binaries used by test
fetch_test_binaries: _out/kubebuilder/bin/kube-apiserver
_out/kubebuilder/bin/kube-apiserver:
	./scripts/fetch-test-binaries.sh


# Run go fmt against code
fmt: tidy
	cd src; go fmt ./...

# Run go vet against code
vet: tidy
	cd src; go vet ./...

# Build the docker image
docker-build:
	docker build . -t ${IMG}

# Push the docker image
docker-push:
	docker push ${IMG}