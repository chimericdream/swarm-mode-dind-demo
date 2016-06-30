FROM docker:rc-dind

MAINTAINER John Harris <john@johnharris.io>

COPY setup-swarm.sh /

RUN chmod +x setup-swarm.sh
