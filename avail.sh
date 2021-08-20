#!/bin/bash -e

char2_name="avail_2char"
char2_prev="$(mktemp)"
[ -e "${char2_name}" ] && firstrun=0 && cp "${char2_name}" "${char2_prev}"

char2_all="$(mktemp)"
echo {{a..z},{0..9},š,ž,õ,ä,ö,ü}{{a..z},{0..9},š,ž,õ,ä,ö,ü}.ee | tr ' ' '\n' | sort > "${char2_all}"

# list is sorted in update.sh, yet it is actually not. bug in update.sh, upstream.
sort list | comm -13 - "${char2_all}" > "${char2_name}"

if [ "${firstrun}" = 0 ]; then
    char2_nolonger_avail="$(comm -13 "${char2_name}" "${char2_prev}" | sed 's/^/-/g')"
    char2_newly_avail="$(comm -23 "${char2_name}" "${char2_prev}" | sed 's/^/+/g')"

    if [ -n "${char2_newly_avail}" ] || [ -n "${char2_nolonger_avail}" ]; then
        printf "\n2char changes:\n"
    fi

    if [ -n "${char2_newly_avail}" ]
    then
        printf '%s\n' "${char2_newly_avail}"
    fi

    if [ -n "${char2_nolonger_avail}" ]
    then
        printf '%s\n' "${char2_nolonger_avail}"
    fi
fi

# cleanup by container
