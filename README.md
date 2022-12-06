# Advent of Code 2022 - Mathew Fleisch

[![Build binaries](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml/badge.svg)](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml)

The [Advent of Code](https://adventofcode.com/) is a programming puzzle challenge that gives participants two coding challenges each day during the month of December. This repository holds my submission/answers for these challenges. I am going to try and do all of them in bash, because I hate myself. This year with bash >=v4. Enjoy. Reasons™

## Automation

Pushing git tags to this repository will [execute each day's answer](https://github.com/mathew-fleisch/adventofcode2022/actions/workflows/release.yaml) in a [github action](.github/workflows/release.yaml) and save the answers as a txt file in the [release artifacts](https://github.com/mathew-fleisch/adventofcode2022/releases) for that day's tag (format: YYYY.MM.DD). After the release notes have been added an automatic tweet is generated to share the milestone on [my twitter feed](https://twitter.com/draxiomatic). 


## Usage

Running the makefile targets 'seed' and 'run' will create stubs for any missing script and execute each challenge script in sequential order. Note: `export DEBUG=1` to see more information as each challenge script is executed. See `make help` for more information.

```bash
make run
```

To run a single day use the makefile target `run-day` and set the variable `TDAY` to the day of the month (with padded zero for days before the 10th)

```bash
$ TDAY=01 make run-day
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
  - [2022-12-02 - Rock Paper Scissors](02)
    - [Challenge 1](02/challenge1.sh) - calculate win/loss/draw
    - [Challenge 2](02/challenge2.sh) - expect win/loss/draw
  - [2022-12-03 - Rucksack Reorganization](03)
    - [Challenge 1](03/challenge1.sh) - cut string in half, and count duplicate letters
    - [Challenge 2](03/challenge2.sh) - count duplicate letters in groups of three strings
  - [2022-12-04 - Camp Cleanup](04)
    - [Challenge 1](04/challenge1.sh) - overlapping integers (intersection)
    - [Challenge 2](04/challenge2.sh) - overlapping integers (union)
  - [2022-12-05 - Supply Stacks](05)
    - [Challenge 1](05/challenge1.sh) - multidimensional array manipulation
    - [Challenge 2](05/challenge2.sh) - multidimensional array manipulation++
 