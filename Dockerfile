FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Enable 32-bit packages for Wine.
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    dbus-x11 \
    firefox-esr \
    lightdm \
    net-tools \
    nano \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    sudo \
    wget \
    curl \
    xorg \
    xorgxrdp \
    xrdp \
    xfce4 \
    xfce4-goodies \
    wine \
    wine32 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Demo login. Change this before exposing the service publicly.
RUN echo 'root:root' | chpasswd

# XRDP/Xorg configuration.
RUN mkdir -p /run/dbus /var/run/dbus /tmp/.X11-unix \
 && chmod 1777 /tmp/.X11-unix \
 && printf 'allowed_users=anybody\nneeds_root_rights=yes\n' > /etc/X11/Xwrapper.config \
 && printf 'startxfce4\n' > /root/.xsession \
 && chmod 700 /root/.xsession \
 && dbus-uuidgen > /var/lib/dbus/machine-id \
 && adduser xrdp ssl-cert

# Use the Xorg backend and start XFCE for every XRDP session.
RUN sed -i 's/^crypt_level=.*/crypt_level=low/' /etc/xrdp/xrdp.ini \
 && sed -i 's/^security_layer=.*/security_layer=rdp/' /etc/xrdp/xrdp.ini \
 && printf '#!/bin/sh\nif [ -r /etc/profile ]; then . /etc/profile; fi\nif [ -r ~/.profile ]; then . ~/.profile; fi\nexec startxfce4\n' > /etc/xrdp/startwm.sh \
 && chmod +x /etc/xrdp/startwm.sh

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3389
CMD ["/start.sh"]
