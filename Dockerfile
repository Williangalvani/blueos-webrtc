from bluerobotics/companion-base:v0.0.2

COPY setup.sh /setup.sh
RUN /setup.sh

COPY settings/* /opt/janus/etc/janus/
COPY html /html

LABEL version="1.0.0"
LABEL permissions '\
{\
    "NetworkMode": "host"\
}'
LABEL authors '[\
    {\
        "name": "Willian Galvani",\
        "email": "willian@bluerobotics.com"\
    }\
]'
LABEL docs ''
LABEL company '{\
        "about": "",\
        "name": "Blue Robotics",\
        "email": "support@bluerobotics.com"\
    }'
LABEL readme 'https://raw.githubusercontent.com/Williangalvani/blueos-webrtc/{tag}/readme.md'
LABEL website 'https://github.com/Williangalvani/blueos-webrtc'
LABEL support 'https://github.com/Williangalvani/blueos-webrtc/issues'

LABEL requirements="core >= 1"
COPY start.sh /start.sh
ENTRYPOINT /start.sh
