IMAGE?="devenv"
COMMITIMAGE="devenv-commited"
MOUNTDIR?=$(shell pwd)
NANORC?="https://nanorc.dfil.es"

build:
	docker build --rm --build-arg NANORC=$(NANORC) -t $(IMAGE) .
.PHONY: build

r:
	docker run -it -P --rm $(IMAGE) bash
.PHONY: r
run:
	docker run -it -P  $(IMAGE) bash
.PHONY: run

run-with-strace:
	  docker run -it -P --cap-add SYS_PTRACE $(IMAGE) bash
.PHONY: run-with-strace

run-mount:
	docker run -it -P --rm -v $(MOUNTDIR):/$$(basename $(MOUNTDIR)) $(IMAGE) bash
.PHONY: run-mount

run-mount-with-strace:
	  docker run -it -P --cap-add SYS_PTRACE -v $(MOUNTDIR):/$$(basename $(MOUNTDIR)) $(IMAGE) bash
.PHONY: run-mount-with-strace

exec:
	$(eval CONTAINER := $(shell docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q))
	docker exec -it $(CONTAINER) bash
.PHONY: exec

commit:
	$(eval CONTAINER := $(shell docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q))
	docker commit $(CONTAINER) $(COMMITIMAGE)
.PHONY: commit

kill:
	docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q | xargs docker kill
.PHONY: kill
