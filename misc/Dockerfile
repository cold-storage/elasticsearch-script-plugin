FROM elasticsearch:6.6.0

# To build this image and use it with docker-compose.yml
# From elasticsearch-script-plugin project root folder run
#
# docker build -f misc/Dockerfile -t quick-es .
#
# docker-compose -f misc/docker-compose.yml up
# docker-compose -f misc/docker-compose.yml down
#

COPY build/elasticsearch-script-plugin.zip /

RUN bin/elasticsearch-plugin install file:///elasticsearch-script-plugin.zip
