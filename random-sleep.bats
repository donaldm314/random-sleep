#!/usr/bin/env bats

# So we can pass flags to run
bats_require_minimum_version 1.5.0

setup() {
    export random_sleep="${BATS_TEST_DIRNAME}"/random-sleep.sh
    source $random_sleep
}

@test "Exits 1 if no args provided" {
    run parse_args
    [ "${status}" -eq 1 ]
}

@test "Exits 2 if multiple args provided" {
    run parse_args 1 2
    [ "${status}" -eq 2 ]
}

@test "Exits 0 if passed an integer" {
    run parse_args 1
    [ "${status}" -eq 0 ]
}

@test "Exits 0 if passed a number" {
    run parse_args 1.0
    [ "${status}" -eq 0 ]
}
