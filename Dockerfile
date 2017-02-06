FROM jkirkby91/ubuntusrvbase:latest
MAINTAINER James Kirkby <james.kirkby@sonyatv.com>

# Install packages specific to our project
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --force-yes --fix-missing && \
apt-get remove --purge -y software-properties-common build-essential {{SERVICE}} && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

# Port to expose (default: {{SERVICE_PORT}})
EXPOSE {{SERVICE_PORT}}

# Copy apparmor conf
#COPY confs/apparmor/memcached.conf /etc/apparmor/memcached.conf

# Copy memcached conf
COPY confs/{{SERVICE}}/{{SERVICE}}.conf /etc/{{SERVICE}}.conf

# Copy supervisor conf
COPY confs/supervisord/supervisord.conf /etc/supervisord.conf

COPY start.sh /start.sh

RUN chmod 777 /start.sh

# Set entrypoint
CMD ["/bin/bash", "/start.sh"]
