#!/bin/sh

ERROR=0

# get the help
HELP=$( ./check_ssl_cert --help )

# list all the command line options

for option in $( grep '^[ ]*-.*)$' check_ssl_cert | sed -e 's/^[ ]*//' -e 's/)//' ) ; do

    case "${option}" in
        '|'|'--'|'-*')
            continue
            ;;
        *)

            # check if the option is documented in the help.txt file
            if ! grep -q -- "${option}" help.txt ; then
                echo "Error: ${option} is not documented in help.txt"
                ERROR=1
            fi

            # check if the option is documented in check_ssl_cert

            if ! echo "${HELP}" | grep -q -- "${option}" ; then
                echo "Error: ${option} is not documented in the help (--help_)"
                ERROR=1
            fi

            # check if the option is documented in README.md

            if ! grep -q -- "${option}" README.md ; then
                echo "Error: ${option} is not documented in README.md"
                ERROR=1
            fi

            # check if the option is documented in the man page

            if ! grep -q -- "${option}" check_ssl_cert.1 ; then
                echo "Error: ${option} is not documented in check_ssl_cert.1"
                ERROR=1
            fi


            ;;

    esac

done

# check if the option descriptions are present in all the files

while read line; do

    option=$( echo "${line}" | sed 's/;.*//' )
    description=$( echo "${line}" | sed 's/[^;]*;//' )

    if ! grep -q "${description}" check_ssl_cert ; then
        echo "Error: the description of option '${option}' '${description}' is not present in check_ssl_cert"
        ERROR=1
    fi

    if ! grep -q "${description}" check_ssl_cert.1 ; then
        # check for automatically generated options
        if ! echo "${description}" | grep -q '${' ; then
            echo "Error: the description of option '${option}' '${description}' is not present in check_ssl_cert.1"
            ERROR=1
        fi
    fi

    # if ! grep -q "${line}" README.md ; then
    #     echo "Error: the description of option ${option} '${description}' is not the same in README.md"
    #     ERROR=1
    # fi

done < help.txt


exit "${ERROR}"
