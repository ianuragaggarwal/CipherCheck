#!/usr/bin/env bash
# OpenSSL requires the port number.
SERVER=$1
PROTOCOL=$2
DELAY=1
PROTOCOLARRAY=(tls1 tls1_1 tls1_2 tls1_3);
CIPHERTYPE="cipher";
if [ -z $PROTOCOL ]; then PROTOCOL="tls1_2"; fi
if [[ " ${PROTOCOLARRAY[*]} " =~ " ${PROTOCOL} " ]]; then VALIDPROTOCOL="true"; fi
if [ X$VALIDPROTOCOL != X"true" ]; then echo "Protocol enter is not valid. Please select tls1, tls1_1, tls1_2, tls1_3"; exit 1; fi;
if [ -z $SERVER ]; then echo "Server not set..exiting. Usage ./CiperCheck.sh <targethost:port> [protocol]"; exit 1; fi
PROTOCOLSPEC="${PROTOCOL^^}";
echo "Testing server $SERVER using $PROTOCOLSPEC protocol specifier. It will take sometime to test all Ciphers. Please wait for test to complete!";
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')
count=`echo $ciphers | wc -w`;
echo Obtaining cipher list from $(openssl version). Total num of Ciphers found: [$count]. Test will only print supported ciphers!
if [ $PROTOCOL == "tls1_3" ]; then CIPHERTYPE="ciphersuites"; fi
for cipher in ${ciphers[@]}
do
    echo -en "\033[2K\\r"
    echo -en Testing cipher "[$cipher] Please Wait...!\\r";
    sleep $DELAY;
    echo -en "\033[2K\\r"
    result=$(echo -n | openssl s_client -$CIPHERTYPE "$cipher"  -connect $SERVER -$PROTOCOL 2>&1)
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
