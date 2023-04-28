from bluerobotics/companion-base:v0.0.2

COPY setup.sh /setup.sh
RUN /setup.sh

COPY settings/* /opt/janus/etc/janus/
COPY html /html

LABEL version="1.0.1"
LABEL permissions='\
{\
    "NetworkMode": "host"\
}'
LABEL authors='[\
    {\
        "name": "Willian Galvani",\
        "email": "willian@bluerobotics.com"\
    }\
]'
LABEL company='{\
        "about": "",\
        "name": "Blue Robotics",\
        "email": "support@bluerobotics.com"\
    }'
LABEL type="other"
LABEL readme='https://raw.githubusercontent.com/Williangalvani/blueos-webrtc/{tag}/readme.md'
LABEL links='{\
        "website": "https://github.com/Williangalvani/blueos-webrtc",\
        "support": "https://github.com/Williangalvani/blueos-webrtc/issues"\
    }'

LABEL requirements="core >= 1.1"
COPY start.sh /start.sh
ENTRYPOINT /start.sh
