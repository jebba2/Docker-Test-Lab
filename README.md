**LAMP Server using Docker-Compose**

This is your typical LAMP (using Docker Nginx Mariadb PHP) stack environment for development.  It has been modified to suite some needs (For example, the MariaDB uses restful and transport encryption) and are outlined below. 

Before starting, it is necessary to install Docker and docker-compose

*There is stubs for using [Let's Encrypt] (https://letsencrypt.org/) to configure SSL for NGINX and in the docker-compose file for automatic renewals.*

---

# INSTALLATION

1. Install [Docker] (https://www.docker.com/) and [docker-compose] (https://docs.docker.com/compose/)
2. To start the stack environment, simply type in "docker-compose up".  This will download the components and once finished, it will start all the applications.  You can review this to make sure that there were no errors and everything started correctly.
3. Once started for the first time, you can use control-C to stop all the services and start up all the applications to run in the background by using the "docker-compose up -d" command.
4. You can connected to MariaDB (mysql) using your favorite client.  By using localhost or 127.0.0.1 for the hostname/ip address if running locally if not please use the dns name or ip address of the server running this docker stack environment.  **Please remember to change the root user's password as it is not secure for most uses**

TLS is not forced if you are using any of the mysql cli tools you will have to specify using ssl/tls (For example, mysql -h 127.0.0.1 -u root -p --ssl).  The certificates to be used with the clients can be found in ./data/mariadb/certs and the have client in the name.

The statement, SHOW GLOBAL VARIABLES LIKE '%ssl%';, will display values related to SSL.  Simply, look for have_ssl and it should have the value of "YES" (this shows that SSL/TLS is enabled)

*It has been discovered through many hours of research and testing that [SequelPro] (https://sequelpro.com/) for OSX does not support tls/ssl connections even through the client has settings for it.*

5. Please see the MariaDB Section in order to re-create both the certificates and the encryption keys.  If this is running under a localhost environment for testing you may elect to skip this step.  But remember, the certificates and keys that are used by this repo are on the internet and should not be considered secure.

6. You can connect to the webserver simply my using http://127.0.0.1 or http://localhost (if running the docker stack locally or substitute the FQDN/IP of the computer running the docker stack).  To view all the php extensions running:  http://127.0.0.1/phpinfo.php,  All the webpages are stored in ./data/websites/gsu_test and this location can be changed in the NGINX config file (see under NGINX).

---

# APPLICATIONS USED AND THEIR CARE AND FEEDING

---

## [NGINX] (https://nginx.org/en/)

nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server (think swiss army knife).  This replaces our Apache Server in the stack as NGINX as it is more flexible, efficient, and somewhat easier to use.

1. The config file for NGINX can be found in /data/nginx/app.conf.
2. There are subs in the config file for SSL.
3. Configured to use PHP-FPM
4. Webpages are stored in /data/websites - it is configured to use /data/websites/gsu_test.  
This can be changed in the config file for NGINX
5. The default index for pages is index.php

---

## [PHP-FPM] (https://www.php.net/manual/en/install.fpm.php)

This is our PHP implementation.  It is configured with commonly used extensions.  Please use phpinfo() to view all of them.

1. The docker file for PHP 8.1.1 is currently used in the docker-compose file and can be found in ./php_8.1.1
2. There is a stub for an older version of PHP 7.4 (./php_7.4) but is currently not being used in this project.

---

## [MariaDB] (https://mariadb.org/)

MariaDB is a community-developed, commercially supported fork of the MySQL relational database management system, intended to remain free and open-source software under the GNU General Public License. Development is led by some of the original developers of MySQL, who forked it due to concerns over its acquisition by Oracle Corporation in 2009.

MariaDB is used in this stack because it allows us to use both restful and transport encryption.

1. The config file for MariaDB can be found in /data/mariadb/my.cnf and other config files can be found in /data/mariadb/maria.conf.d - These are shared files/folders with the docker container so they can be modified and all you need to do is restart the docker-compose file ( command: **docker-compose down** )
2. All the database files are stored in /data/database
3. The root user using password "root" is configured in the docker-compose file.  **It is recommended that you change this** 
4. [TLS] (https://mariadb.com/kb/en/secure-connections-overview/) is configured.  The certificates can be found in ./data/mariadb/certs folder.  There is a script ( generate_certs.sh ) to automatically generate the ca, server certification, and client certificate (please modify to fit your needs).  These certifcates can be used as they do not handle logins, but if you are afraid of man-in-the-middle attacks or have other security concerns please regenerate them.  
5. [Restfull Encryption] (https://mariadb.com/kb/en/data-at-rest-encryption-overview/) is configured.  The keys can be found in ./data/mariadb/encryption.  There is a script (create_keys.sh) in that directory to create/re-create the keys used. 







