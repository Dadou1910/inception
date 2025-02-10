# Base image in Debian 12 (compatible with nginx & OpenSSL)
FROM debian:bookworm

# updates packages, installs webserver (nginx) and openssl (for
# ssl certificate generation)
RUN apt update && apt upgrade -y && apt install -y nginx openssl

# Create directory to store certifs (-p if doesn't already exist)
RUN mkdir -p /etc/nginx/ssl

# Creates self-signed certificate with no passwd for 1 yr,
# encryption key, public key, private certif to my domain name
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=abremont.42.fr"

# Override default nginx settings with my conf file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Default commands when container starts :
# ensures nginx runs in foreground & remains main process in container
CMD ["nginx", "-g", "daemon off;"]
