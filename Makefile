TDAY?=01
DAYS?=$(shell seq -f "%02g" 1 25)
TMPDIR?=/tmp

.PHONY: run
run:
	@echo "==============================================="
	@cat banner.txt
	@echo "  Advent of Code 2022 - Mathew Fleisch"
	@echo "==============================================="
	@echo
	@$(foreach day, $(DAYS), export TDAY=${day} && make run-day --no-print-directory; )

.PHONY: run-day
run-day:
	@echo "<============= 2022/12/${TDAY} =============>" \
		&& echo "#> ./${TDAY}/challenge1.sh ./${TDAY}/input.txt" \
		&& ./${TDAY}/challenge1.sh ./${TDAY}/input.txt \
		&& echo "#> ./${TDAY}/challenge2.sh ./${TDAY}/input.txt" \
		&& ./${TDAY}/challenge2.sh ./${TDAY}/input.txt

.PHONY: docker-build
docker-build:
	docker build -t aoc2022 .

.PHONY: docker-run
docker-run: docker-build
	docker run -it --rm aoc2022

.PHONY: docker-run-mount
docker-run-mount: docker-build
	docker run -it --rm -v ${PWD}:/workspace aoc2022

.PHONY: zip-log
zip-log:
	@mkdir -p $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@cp log-* $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@zip -r $(TMPDIR)/aoc2022-mathew-fleisch-logs.zip $(TMPDIR)/aoc2022-mathew-fleisch-logs