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
    run -0 parse_args 1
}


@test "Random delay is an integer >= 0, <= arg" {
    max=2
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_an_integer ]]
    [[ "${output}" -ge 0 ]]
    [[ "${output}" -le $max ]]
}

@test "Supports 's' suffix for seconds" {
    max="2s"
    run -0 parse_args $max
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_in_seconds ]]
}

@test "Supports 'm' suffix for minutes" {
    max="2m"
    run -0 parse_args $max
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_in_minutes ]]
}

@test "Supports 'h' suffix for hours" {
    max="2h"
    run -0 parse_args $max
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_in_hours ]]
}

@test "Supports 'd' suffix for days" {
    max="2d"
    run -0 parse_args $max
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_in_days ]]
}