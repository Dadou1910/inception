# Base image in Debian 12 (compatible with nginx & OpenSSL)
FROM debian:bookworm

# updates packages, installs :
# php-fpm : nginx can't process php requests directly
# php-mysqli : connects php to MySQL/MariaDB databse
# mariadb-client : needed to connect to an external MariaDB instance
RUN apt update && apt upgrade && apt install -y php-fpm php-mysqli curl mariadb-client

# Allows to modify the way php-fpm manages php processes (my conf file)
COPY www.conf /etc/php/8.2/fpm/pool.d/.
# Copies script in the continers working directory (runs setup commands)
COPY script.sh .
# Grants permissions
RUN chmod +x script.sh
# Makes script run as main process in container
CMD ["./script.sh"]
