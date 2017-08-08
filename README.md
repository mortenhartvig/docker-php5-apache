# docker-php7.1.6-apache
Generate that dockerfile for Prestashop testing!

# Build image
docker build -t "apachessl" .

# If you are running with jwilder/nginx-proxy & JrCs/docker-letsencrypt-nginx-proxy-companion, this works with Prestashop (of course you will then also have to add the "LETSENCRYPT_HOST" and "LETSENCRYPT_EMAIL" in the run command, and have a database and application volume/folder ready for mointing aswell:
docker run -ti --name containerName -d --link aDbContainerName:db -v applicationFiles:/var/www/html -e "VIRTUAL_HOST=subdomain.domain.tld" -e  "VIRTUAL_PROTO=https" -e"VIRTUAL_PORT=443" --user root:2222 apachessl

You may then access subdomain.domain.tld if you have the correct DNS information in your hosts file. Or do it live on a public server.
