#!/bin/bash
# list of stun servers provided by http://olegh.ftp.sh/public-stun.txt
echo -e "start tests on public stun servers\n"
FILE="public-stun.txt"
STUN_RESULTS="stunresults.txt"
RFC=(3489 5389 5780)

if [ -f "${STUN_RESULTS}" ]
then
    rm "${STUN_RESULTS}"
    touch "${STUN_RESULTS}"
    echo "removed previous stun results"
    echo "created ${STUN_RESULTS}"
else
    touch "${STUN_RESULTS}"
    echo "created ${STUN_RESULTS}"
fi

echo -e "\n"

# reads one LINE at a time from FILE
while IFS= read -r LINE
do
    # splits each LINE by ":", stores in ADDR array
    IFS=':' read -ra ADDR <<< "${LINE}"
    COMMAND="./stunclient --mode full ${ADDR[0]} ${ADDR[1]}"

    SERVER_RESULT=""
    CLIENT_OUTPUT=$(${COMMAND})
    while read -r PROGRAM_OUTPUT;
    do
        # append program output from stun client for single stun server test
        SERVER_RESULT="${SERVER_RESULT}, ${PROGRAM_OUTPUT}"
    done <<< "${CLIENT_OUTPUT}"
    echo -e "${COMMAND} ${SERVER_RESULT}\n"

    # append stun client test results for server to file
    echo -e "${LINE}${SERVER_RESULT}\n" >> "${STUN_RESULTS}"
done <"${FILE}"

echo "finish tests on public stun servers"
echo "results written to ${STUN_RESULTS}"
