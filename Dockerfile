from bluerobotics/companion-base:v0.0.1

COPY setup.sh /setup.sh
RUN /setup.sh

COPY settings/* /opt/janus/etc/janus/
COPY html /html

COPY start.sh /start.sh
ENTRYPOINT /start.sh