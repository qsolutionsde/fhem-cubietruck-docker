FROM arm32v7/debian:jessie

# Base
RUN apt-get update && apt-get -qy install apt-utils apt-transport-https wget build-essential
RUN wget -qO - https://debian.fhem.de/archive.key | apt-key add - && echo "deb http://debian.fhem.de/nightly/ /" > /etc/apt/sources.list.d/fhem.list
RUN apt-get update && apt-get -y install fhem 

WORKDIR /opt/fhem

# DbLog
RUN apt-get install -y mysql-client libdbd-mysql libdbd-mysql-perl

# MQTT
RUN cpan -i Net::MQTT::Simple Net::MQTT:Constants Module::Pluggable

# FRITZBOX
RUN apt-get install -y libjson-perl libwww-perl libsoap-lite-perl libjson-xs-perl

# Calendar
RUN apt-get install -y libio-socket-ssl-perl

# SONOS
RUN apt-get install -y libxml-parser-lite-perl

# km200
RUN apt-get install -y libjson-perl libcrypt-rijndael-perl libmime-perl libdigest-perl-md5-perl libdatetime-perl
RUN cpan List::MoreUtils Time::HiRes

COPY start.sh ./start.sh
RUN ["chmod", "+x", "./start.sh"]

RUN echo "attr global nofork 1" >> fhem.cfg

EXPOSE 8083
EXPOSE 7072

# mount /opt/fhem/log to /var/log/fhem to have the logs outside the container
# mount /opt/fhem for the whole installation (needs to be populated before)
CMD ["./start.sh"]
