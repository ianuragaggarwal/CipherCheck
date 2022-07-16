# CipherCheck

CipherCheck is shell script which uses openssl to see what ciphers a target server supports.

Usage <> ./CipherCheck.sh <targethost:port> [protocol]

Protocol if not specified is taken as TLSv1.2.  Please use complete protcol specifier as used by openssl.

e.g. tls1/ tls1_1/ tls1_2/ tls1_3 etc.

![image](https://user-images.githubusercontent.com/109287070/179355824-032c8510-f8ac-45b4-930f-c02b27c3b199.png)
