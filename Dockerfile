from bluerobotics/companion-base:v0.0.2

COPY setup.sh /setup.sh
RUN /setup.sh

COPY settings/* /opt/janus/etc/janus/
COPY html /html

LABEL version="1.0"
LABEL permissions '\
{\
    "NetworkMode": "host"\
}'
LABEL reasonings = '{\
    "network_mode": "Default option"\
}'

LABEL requirements="core >= 1"
COPY start.sh /start.sh
ENTRYPOINT /start.sh
