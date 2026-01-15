CONTAINER_RUNTIME 	?= podman
HUGO_VERSION		?= 0.154.4
IMAGE_NAME		?= hugo:$(HUGO_VERSION)

.PHONY: help
help: # Show this help.
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: image
image: # Builds hugo container for development.
	$(CONTAINER_RUNTIME) build \
		-f Containerfile \
		--build-arg HUGO_VERSION=$(HUGO_VERSION) \
		-t $(IMAGE_NAME) .

.PHONY: site
site: image # Generates a new hugo site.
	$(CONTAINER_RUNTIME) run --rm -it \
		-v "$$PWD:/src:Z" \
		$(IMAGE_NAME) \
		new site site
