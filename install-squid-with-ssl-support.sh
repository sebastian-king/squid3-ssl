#!/bin/bash

squid_version=$(cat apt-cache policy squid | grep Candidate: | awk '{print $2}');

architecture=$(dpkg --print-architecture);

cd /usr/src/

wget https://raw.githubusercontent.com/sebastian-king/squid3-ssl/master/squid-ssl.patch

apt-get source squid
apt-get build-dep squid
apt-get install devscripts build-essential fakeroot libssl-dev #dpkg-dev #for debian
patch squid-ssl.patch  # as of squid 3.5 --with-open-ssl has become --with-openssl

cd "${squid_version}"
./configure
debuild -us -uc -b
cd ../
apt-get install squid-langpack
dpkg -i squid_"${squid_version}"_"${architecture}".deb squid-common_"${squid_version}"_all.deb
