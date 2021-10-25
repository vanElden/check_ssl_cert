#!/bin/sh

# get the help
HELP=$( ./check_ssl_cert --help )

# list all the command line options

for option in $( grep '^[ ]*-.*)$' check_ssl_cert | sed -e 's/^[ ]*//' -e 's/)//' ) ; do

    case "${option}" in
        '|'|'--'|'-*')
            continue
            ;;
        *)

            echo "### checking ${option}"

            # 1) check if the option is documented in check_ssl_cert

            if ! echo "${HELP}" | grep -q -- "${option}" ; then
                echo "Error ${option} is not documented in the help (--help_)"
            fi

            ;;

    esac

done