FROM debian:testing
MAINTAINER Piotr Minkina <projects[i.am.spamer]@piotrminkina.pl>


ENV INCLUDE_PACKAGES="debootstrap docker.io make"

RUN sed -i 's/httpredir\.debian\.org/ftp.debian.org/g' /etc/apt/sources.list

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq install apt-utils \
 && DEBIAN_FRONTEND=noninteractive apt-get -yqq install ${INCLUDE_PACKAGES} \
 && find /var/cache/apt/archives/ /var/lib/apt/lists/ -type f | xargs rm -f
