#!/usr/bin/env bats

# So we can pass flags to run
bats_require_minimum_version 1.5.0

# shellcheck source=/dev/null
setup() {
    export random_sleep="${BATS_TEST_DIRNAME}"/../random-sleep.sh
    source "$random_sleep"
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

@test "Integer regex" {
    int='4'
    # shellcheck disable=SC2154
    [[ "${int}" =~ $is_an_integer ]]
    int='42'
    [[ "${int}" =~ $is_an_integer ]]
    int='421'
    [[ "${int}" =~ $is_an_integer ]]
}

@test "Seconds regex" {
    seconds='2s'
    # shellcheck disable=SC2154
    [[ "${seconds}" =~ $is_in_seconds ]]
    seconds='42s'
    [[ "${seconds}" =~ $is_in_seconds ]]
    seconds='42s'
    [[ "${seconds}" =~ $is_in_seconds ]]
}

@test "Minutes regex" {
    minutes='4m'
    # shellcheck disable=SC2154
    [[ "${minutes}" =~ $is_in_minutes ]]
    minutes='42m'
    [[ "${minutes}" =~ $is_in_minutes ]]
}

@test "Random delay is an integer >= 0, <= arg" {
    max=2
    set_max_sleep $max
    run a_random_amount
    [[ "${output}" =~ $is_an_integer ]]
    [[ "${output}" -ge 0 ]]
    [[ "${output}" -le $max ]]
}

@test "Big delay is an int >= 0, <= arg" {
    max=642
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

@test "Big 's' delay works" {
    max='642s'
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
    # shellcheck disable=SC2154
    [[ "${output}" =~ $is_in_hours ]]
}

@test "Supports 'd' suffix for days" {
    max="2d"
    run -0 parse_args $max
    set_max_sleep $max
    run a_random_amount
    # shellcheck disable=SC2154
    [[ "${output}" =~ $is_in_days ]]
}

@test "Get suffix - no suffix" {
    delay='2'
    run -0 get_suffix $delay
    [[ "${output}" -eq '' ]]
}

@test "Get suffix - (smhd) suffix" {
    for char in 's' 'm' 'h' 'd'; do
        delay="42${char}"
        run -0 get_suffix $delay
        [[ "${output}" == "${char}" ]]
    done
}

@test "Get integer - no suffix" {
    for delay in '1' '23' '432' '24352'; do
        run -0 get_integer $delay
        [[ "${output}" -eq $delay ]]
    done
}