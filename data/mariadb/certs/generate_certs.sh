##############################################
###  Generates Certifications for		   ###
###  MariaDB TLS						   ###
###										   ###
### Created on April 4, 2022               ###
### By: Jeb Barger <jbarger@gsu.edu        ###
##############################################

# Note: Common Name value used for the server and client certificates/keys must each differ # from the Common Name value used for the CA certificate. To avoid any issues, I am setting 
# them as follows. Otherwise, you will get certification verification failed error. Hence 
#set it as follows:
#CA common Name : MariaDB admin
#Server common Name: MariaDB server
#Client common Name: MariaDB client

#!/bin/bash

printf "************************************************************\n"
printf "********* Create Certificate CA                    *********\n"
printf "************************************************************\n"

#Type the following command to create a new CA key:
openssl genrsa 4096 > ca-key.pem

printf "************************************************************\n"
printf "********* For the Common Name, enter MariaDB Admin *********\n"
printf "************************************************************\n"

#Type the following command to generate the certificate using that key:
openssl req -new -x509 -nodes -days 365000 -key ca-key.pem -out ca-cert.pem -subj "/C=US/ST=Georgia/L=Statesboro/O=GSU/OU=Dev/CN=MariaDB Admin"

printf "************************************************************\n"
printf "********* Create Server Certificate                *********\n"
printf "************************************************************\n"

#To create the server key, run:
openssl req -newkey rsa:2048 -days 365000 -nodes -keyout server-key.pem -out server-req.pem -subj "/C=US/ST=Georgia/L=Statesboro/O=GSU/OU=Dev/CN=MariaDB Server"

printf "************************************************************\n"
printf "********* For the Common Name, enter MariaDB Server*********\n"
printf "************************************************************\n"

#Next process the server RSA key, enter:
openssl rsa -in server-key.pem -out server-key.pem

#Finally sign the server certificate, run:
openssl x509 -req -in server-req.pem -days 365000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

printf "************************************************************\n"
printf "********* Create the client TLS/SSL certificate    *********\n"
printf "************************************************************\n"

#To create the client key, run:
openssl req -newkey rsa:2048 -days 365000 -nodes -keyout client-key.pem -out client-req.pem -subj "/C=US/ST=Georgia/L=Statesboro/O=GSU/OU=Dev/CN=MariaDB User"


printf "************************************************************\n"
printf "********* For the Common Name, enter MariaDB User  *********\n"
printf "************************************************************\n"

#Next, process client RSA key, enter:
openssl rsa -in client-key.pem -out client-key.pem

#Finally, sign the client certificate, run:
openssl x509 -req -in client-req.pem -days 365000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem

printf "************************************************************\n"
printf "********* Verifying Certificates                   *********\n"
printf "************************************************************\n"
#### How do I verify the certificates?
openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem


#### Configure the server to use ssl
#ssl-ca=/etc/mysql/ssl/ca-cert.pem
#ssl-cert=/etc/mysql/ssl/server-cert.pem
#ssl-key=/etc/mysql/ssl/server-key.pem


#### Configure the client to use ssl

## MySQL Client Configuration ##
#ssl-ca=/etc/mysql/ssl/ca-cert.pem
#ssl-cert=/etc/mysql/ssl/client-cert.pem
#ssl-key=/etc/mysql/ssl/client-key.pem
##  Force TLS version for client too
#tls_version = TLSv1.2,TLSv1.3
### This option is disabled by default ###
### ssl-verify-server-cert ###


### Verify the SSL is running on the Server

#SHOW VARIABLES LIKE '%ssl%';



