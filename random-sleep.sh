#!/usr/bin/env bash

integer='^[0-9]+$'
seconds='^[0-9]+s$'
minutes='^[0-9]+m$'
hours='^[0-9]+h$'
days='^[0-9]+d$'

_MAX_SLEEP=

usage() {
    cat <<EOF
${0} MAX_DELAY[SUFFIX]
    Where MAX_DELAY is an integer, optionally with the SUFFIX 's' for seconds (the default), 'm' for minutes, 'h' for hours, or 'd' for days.
    Sleeps for a random delay between 0 and <max sleep>.
EOF
}

set_max_sleep() {
    _MAX_SLEEP=$1
}

get_max_sleep() {
    echo ${_MAX_SLEEP}
}

parse_args() {
    if [ $# -eq 0 ]; then
        echo "ERROR: No maximum delay specified"
        usage
        exit 1
    elif [ $# -gt 1 ]; then
        echo "ERROR: Too many args supplied!"
        usage
        exit 2
    fi

    if [[ $1 =~ $integer ]] || 
        [[ $1 =~ $seconds ]] ||
        [[ $1 =~ $minutes ]] ||
        [[ $1 =~ $hours ]] ||
        [[ $1 =~ $days ]]; then
        set_max_sleep $1
    else
        echo "ERROR: Bad argument!"
        usage
        exit 3
    fi
}

a_random_amount() {
    local max_sleep=$(get_max_sleep)
    RANDOM=$$  # seed with our PID
    integer=$(echo $max_sleep | sed 's/[smhd]//')
    suffix=$(echo $max_sleep | sed 's/[0-9]//')
    random_integer=$(expr $RANDOM % ${integer})
    random_sleep="${random_integer}${suffix}"
    echo "${random_sleep}"
}


main() {
    parse_args $@
    sleep $(a_random_amount)
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main $@
fi