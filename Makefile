TDAY?=01
DAYS?=$(shell seq -f "%02g" 1 25)
TMPDIR?=/tmp

##@ Makefile Targets

.PHONY: help
help: ## Display this dialog
	@cat banner.txt
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


.PHONY: docker-build
docker-build: ## Build a local docker container with dependencies preinstalled
	docker build -t aoc2022 .

.PHONY: docker-run
docker-run: docker-build ## Run solution for every day in a docker container
	docker run -it --rm -e DEBUG aoc2022

.PHONY: docker-mount
docker-mount: docker-build ## Mount source code in a docker container
	docker run -it --rm -e DEBUG --entrypoint /bin/bash -v ${PWD}:/workspace aoc2022

.PHONY: run
run: ## Run solution for every day (set DEBUG=1 for more verbose output)
	@cat banner.txt
	@$(foreach day, $(DAYS), export TDAY=${day} && make run-day --no-print-directory; )

.PHONY: run-day
run-day: ## Run solution for a specific day (TDAY with padded zeros before the 10th)
	@echo "<============= 2022/12/${TDAY} =============>" \
		&& echo "#> ./${TDAY}/challenge1.sh ./${TDAY}/input.txt" \
		&& ./${TDAY}/challenge1.sh ./${TDAY}/input.txt \
		&& echo "#> ./${TDAY}/challenge2.sh ./${TDAY}/input.txt" \
		&& ./${TDAY}/challenge2.sh ./${TDAY}/input.txt

.PHONY: zip-log
zip-log: ## Wrap up logs in zip for ci/release artifacts
	@mkdir -p $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@cp log-* $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@zip -r $(TMPDIR)/aoc2022-mathew-fleisch-logs.zip $(TMPDIR)/aoc2022-mathew-fleisch-logs
