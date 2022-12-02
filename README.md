# Advent of Code 2022 - Mathew Fleisch

[![Build binaries](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml/badge.svg)](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml)

The [Advent of Code](https://adventofcode.com/) is a programming puzzle challenge that gives participants two coding challenges each day during the month of December. This repository holds my submission/answers for these challenges. I am going to try and do all of them in bash, because I hate myself. This year with bash >=v4. Enjoy.

## Automation

Pushing git tags to this repository will [execute each day's answer](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml) in a [github action](.github/workflows/release.yaml) and save the answers as a txt file in the [release artifacts](https://github.com/mathew-fleisch/adventofcode2022/releases) for that day's tag (format: YYYY.MM.DD). After the release notes have been added an automatic tweet is generated to share the milestone on [my twitter feed](https://twitter.com/draxiomatic). 


## Usage

Running the makefile targets 'seed' and 'run' will create stubs for any missing script and execute each challenge script in sequential order. Note: `export DEBUG=1` to see more information as each challenge script is executed.

```bash
make run
```

To run a single day use the makefile target `run-day` and set the variable `TDAY` to the day of the month (with padded zero for days before the 10th)

```bash
$ TDAY=01 make run-day
========================================
  Advent of Code 2022[01] - Mathew Fleisch
========================================

<============= 2022/12/01 =============>
#> ./01/challenge1.sh ./01/input.txt
REDACTED
#> ./01/challenge2.sh ./01/input.txt
REDACTED
```

## Challenges

 - [2022-12-01 - Calorie Counting](01)
    - [Challenge 1](01/challenge1.sh) - counting calories largest value
    - [Challenge 2](01/challenge2.sh) - counting sum of largest three calories values
 