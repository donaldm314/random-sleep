#!/usr/bin/env bats

# So we can pass flags to run
bats_require_minimum_version 1.5.0

setup() {
    export random_sleep="${BATS_TEST_DIRNAME}"/../random-sleep
}

@test "Should pass" {
    true
}

@test "Exits non-zero if no args provided" {
    run ${random_sleep}
    [ "${status}" -ne 0 ]
}
