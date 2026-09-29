#!/bin/bash
set -u

mkdir -p /run/dbus /var/run/dbus /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Railway containers do not use systemd.
if ! pgrep -x dbus-daemon >/dev/null 2>&1; then
    dbus-daemon --system --fork || true
fi

# Audio is optional; do not let it stop XRDP from starting.
pulseaudio --system --disallow-exit --disable-shm >/tmp/pulseaudio.log 2>&1 || true

# Start the session manager, then keep xrdp itself in the foreground.
xrdp-sesman --nodaemon >/tmp/xrdp-sesman.log 2>&1 &
SES_PID=$!

cleanup() {
    kill "$SES_PID" 2>/dev/null || true
    pkill -x xrdp 2>/dev/null || true
}
trap cleanup EXIT INT TERM

# Keep the main process attached to PID 1 so Railway sees a healthy running container.
exec xrdp --nodaemon
