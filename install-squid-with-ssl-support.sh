#!/bin/bash

squid_version=$(apt-cache policy squid | grep Candidate: | awk '{print $2}' | awk -F'-' '{print $1}');

architecture=$(dpkg --print-architecture);

cd /usr/src/

wget https://raw.githubusercontent.com/sebastian-king/squid3-ssl/master/squid-ssl.patch -O squid-ssl.patch

apt-get source squid
apt-get build-dep squid
apt-get install devscripts build-essential fakeroot libssl-dev #dpkg-dev #for debian

cd "squid3-${squid_version}"

patch -p0  <../squid-ssl.patch  # as of squid 3.5 --with-open-ssl has become --with-openssl

./configure
debuild -us -uc -b
cd ../
apt-get install squid-langpack
dpkg -i squid_"${squid_version}"_"${architecture}".deb squid-common_"${squid_version}"_all.deb

#viola, https_port is now enabled and working in squid
