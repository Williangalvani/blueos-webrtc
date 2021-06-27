from bluerobotics/companion-base:v0.0.1

RUN apt update && apt install -y libmicrohttpd-dev libjansson-dev libnice-dev \
	libssl-dev  libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev \
	pkg-config gengetopt libtool automake git gcc make libconfig-dev

COPY setup.sh /setup.sh
RUN /setup.sh

COPY settings/* /opt/janus/etc/janus/
COPY html /html

COPY start.sh /start.sh
ENTRYPOINT /start.sh