#!/bin/bash
set -e

# Railway containers do not run systemd, so start the required daemons directly.
mkdir -p /run/dbus /var/run/dbus /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Start D-Bus if it is not already running.
if ! pgrep -x dbus-daemon >/dev/null 2>&1; then
    dbus-daemon --system --fork || true
fi

# Start PulseAudio for XRDP audio support (audio is optional).
pulseaudio --start --system --disallow-exit --disable-shm 2>/dev/null || true

# Start XRDP session manager in the background and XRDP itself in the foreground.
# Keeping XRDP in the foreground prevents Railway from seeing an exited container.
xrdp-sesman --nodaemon &
SES_PID=$!

cleanup() {
    kill "$SES_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

exec xrdp --nodaemon
