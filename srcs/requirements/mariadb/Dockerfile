# Base image is Debian 12
FROM debian:bookworm

# pudates packages, installs server (database server) and client
# (commad-line client to interact with database) -> mysqld & mysql
RUN apt update && apt upgrade -y && apt install -y mariadb-server mariadb-client

# Overrides the default MariaDB config with script & conf I created
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY script.sh /usr/local/bin/

# Makes the script executable
RUN chmod +x /usr/local/bin/script.sh

# Runs the script as the main process at container init
ENTRYPOINT ["/usr/local/bin/script.sh"]