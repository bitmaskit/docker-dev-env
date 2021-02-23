IMAGE?="devenv"
COMMITIMAGE="devenv-commited"
MOUNTDIR?=$(shell pwd)
NANORC?="https://nanorc.dfil.es"
build:
	docker build --rm --build-arg NANORC=$(NANORC) -t $(IMAGE) .
run:
	docker run -it -P $(IMAGE) bash
run-with-strace:
	docker run -it -P --cap-add SYS_PTRACE $(IMAGE) bash
run-mount:
	docker run -it -P -v $(MOUNTDIR):/$$(basename $(MOUNTDIR)) $(IMAGE) bash
exec:
	$(eval CONTAINER := $(shell docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q))
	  docker exec -it $(CONTAINER) bash
kill:
	docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q | xargs docker kill
commit:
	$(eval COUNTAINER := $(shell docker ps -f "ancestor=$(IMAGE)" -f "status=running" -q))
	  docker commit $(CONTAINER) $(COMMITIMAGE)
