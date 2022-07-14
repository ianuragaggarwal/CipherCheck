# CipherCheck

CipherCheck is shell script which uses openssl to see what ciphers a target server supports.

Usage <> ./CipherCheck.sh <targethost:port> [protocol]

Protocol if not specified is taken as TLSv1.2.  Please use complete protcol specifier as used by openssl.

e.g. tls1/ tls1_1/ tls1_2/ tls1_3 etc.

![image](https://user-images.githubusercontent.com/109287070/178980169-01989f9d-0d24-4d13-92c1-7605e96b60d9.png)
