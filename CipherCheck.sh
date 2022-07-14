#!/usr/bin/env bash
# OpenSSL requires the port number.
SERVER=$1
PROTOCOL=$2
if [ -z $PROTOCOL ]; then PROTOCOL="-tls1_2"; fi
if [ -z $SERVER ]; then echo "Server not set..exiting !!!"; exit 1; fi
echo "Testing server $SERVER using $PROTOCOL protocol specifier. It will take sometime to test all Ciphers. Please wait for test to complete!";
PROTOCOLSPEC="${PROTOCOL^^}"; PROTOCOLSPEC=`echo $PROTOCOLSPEC | cut -c 2-`;
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')
count=`echo $ciphers | wc -w`;
echo Obtaining cipher list from $(openssl version). Total num of Ciphers found: [$count]. Test will only print supported ciphers!
for cipher in ${ciphers[@]}
do
    echo -en "\033[2K\\r"
    echo -en Testing cipher "[$cipher] Please Wait...!\\r";
    sleep $DELAY;
    echo -en "\033[2K\\r"
    result=$(echo -n | openssl s_client -cipher "$cipher"  -connect $SERVER $PROTOCOL 2>&1)
    if [[ "$result" =~ ":error:" ]] ; then
        error=$(echo -n $result | cut -d':' -f6)
        #echo NO \($error\)
    else
        #if echo $result | grep -vq "Verify return code: 0 (ok)"; then
        if echo $result | grep -qv "Cipher    : 0000"; then
            echo -e Tested Ok'\t'[$PROTOCOLSPEC]' '[$cipher]
        else
            echo UNKNOWN RESPONSE
            echo $result
         fi
    fi
sleep $DELAY
done
