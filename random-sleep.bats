#!/usr/bin/env bats

# So we can pass flags to run
bats_require_minimum_version 1.5.0

setup() {
    export random_sleep="${BATS_TEST_DIRNAME}"/random-sleep.sh
    source $random_sleep
}

@test "Exits 1 if no args provided" {
    run -1 parse_args
}

@test "Exits 2 if multiple args provided" {
    run -2 parse_args 1 2
}

@test "Exits 0 if passed an integer" {
    run parse_args 1
}

@test "Exits 0 if passed a number" {
    run parse_args 1.0
}
