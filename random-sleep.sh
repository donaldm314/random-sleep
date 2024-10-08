#!/usr/bin/env bash

usage() {
    cat <<EOF

Usage: $(basename "${0}") MAX_DELAY[SUFFIX]

Where MAX_DELAY is an integer, optionally with the
SUFFIX 's' for seconds (the default), 'm' for minutes,
'h' for hours, or 'd' for days.

Sleeps for a random delay between 0 and MAX_DELAY,
by calling $(which sleep).
EOF
}

is_an_integer='^[0-9]+$'
is_in_seconds='^[0-9]+s$'
is_in_minutes='^[0-9]+m$'
is_in_hours='^[0-9]+h$'
is_in_days='^[0-9]+d$'

_MAX_SLEEP=

set_max_sleep() {
    _MAX_SLEEP="$1"
}

get_max_sleep() {
    echo "${_MAX_SLEEP}"
}

parse_args() {
    if [ $# -eq 0 ]; then
        echo "ERROR: No maximum delay specified!"
        usage
        exit 1
    elif [ $# -gt 1 ]; then
        echo "ERROR: Too many args supplied!"
        usage
        exit 2
    elif [[ $1 =~ $is_an_integer ]] ||
        [[ $1 =~ $is_in_seconds ]] ||
        [[ $1 =~ $is_in_minutes ]] ||
        [[ $1 =~ $is_in_hours ]] ||
        [[ $1 =~ $is_in_days ]]; then
        set_max_sleep "$1"
    else
        echo "ERROR: Bad argument!"
        usage
        exit 3
    fi
}

get_suffix() {
    local delay=$1
    suffix=${delay//[0-9]/}
    echo "${suffix}"
}

get_integer() {
    local delay=$1
    integer=${delay//[smhd]/}
    echo "${integer}"
}

a_random_amount() {
    local max_sleep
    max_sleep=$(get_max_sleep)
    integer=$(get_integer "$max_sleep")
    suffix=$(get_suffix "$max_sleep")

    RANDOM=$$ # seed with our PID
    random_integer=$((RANDOM % integer))
    random_sleep="${random_integer}${suffix}"
    logger "$(basename "${0}") PID $$ sleeping for ${random_sleep}"
    echo "${random_sleep}"
}

main() {
    parse_args "$@"
    sleep "$(a_random_amount)"
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
