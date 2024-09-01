#!/usr/bin/env bash

integer='^[0-9]+$'

_MAX_SLEEP=

set_max_sleep() {
    _MAX_SLEEP=$1
}

get_max_sleep() {
    echo ${_MAX_SLEEP}
}

parse_args() {
    if [ $# -eq 0 ]; then
        echo "ERROR: No maximum delay specified"
        exit 1
    elif [ $# -gt 1 ]; then
        echo "ERROR: Too many args supplied!"
        exit 2
    fi

    set_max_sleep $1
}

get_random_sleep() {
    local max_sleep=$(get_max_sleep)
    RANDOM=$$  # seed with our PID
    random_delay=$(expr $RANDOM % ${max_sleep})
    echo $random_delay >> log
    echo $random_delay
}

call_sleep() {
    sleep $(get_random_sleep)
}

main() {
    parse_args $@
    call_sleep
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main $@
fi