TDAY?=01
DAYS?=$(shell seq -f "%02g" 1 25)
CHALLENGES?=challenge1 challenge2
TMPDIR?=/tmp

.PHONY: run
run: seed
	@echo "========================================"
	@echo "  Advent of Code 2022 - Mathew Fleisch"
	@echo "========================================"
	@echo
	@$(foreach day, $(DAYS), \
		echo "<============= 2022/12/${day} =============>" \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> ./${day}/${challenge}.sh ./${day}/input.txt" \
				&& ./${day}/${challenge}.sh ./${day}/input.txt; ))

.PHONY: run-day
run-day:
	@echo "========================================"
	@echo "  Advent of Code 2022[$(TDAY)] - Mathew Fleisch"
	@echo "========================================"
	@echo
	@echo "<============= 2022/12/${TDAY} =============>" \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> ./${TDAY}/${challenge}.sh ./${TDAY}/input.txt" \
				&& ./${TDAY}/${challenge}.sh ./${TDAY}/input.txt; )


.PHONY: seed
seed:
	@echo "========================================"
	@echo "  Advent of Code 2022 - Mathew Fleisch"
	@echo "========================================"
	@echo
	@$(foreach day, $(DAYS), \
		echo "<============= Seeding 2022/12/${day} =============>" \
			&& echo "#> mkdir -p ./${day} && touch ./${day}/input.txt" \
			&& mkdir -p ./${day} \
			&& touch ./${day}/input.txt \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> echo "#!/bin/bash\necho \"Not Implemented\"" > ./${day}/${challenge}.sh" \
				&& if ! [ -f "./${day}/${challenge}.sh" ]; then \
					echo "#!/bin/bash\necho \"Not Implemented\"" > ./${day}/${challenge}.sh; \
				fi \
				&& echo "#> chmod +x ./${day}/${challenge}.sh" \
				&& chmod +x ./${day}/${challenge}.sh; ))

.PHONY: zip-log
zip-log:
	@mkdir -p $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@cp log-* $(TMPDIR)/aoc2022-mathew-fleisch-logs
	@zip -r $(TMPDIR)/aoc2022-mathew-fleisch-logs.zip $(TMPDIR)/aoc2022-mathew-fleisch-logs