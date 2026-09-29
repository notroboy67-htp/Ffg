# Debian XFCE + XRDP for Railway

This image runs Debian + XFCE + XRDP and exposes RDP on TCP port 3389.

## Railway

1. Put `Dockerfile` and `start.sh` in the repository root.
2. Deploy the GitHub repository in Railway.
3. Wait for the Docker build and deployment to finish.
4. In the service **Settings → Networking → TCP Proxy**, create a TCP proxy for internal port **3389**.
5. Railway will give you a public endpoint such as `xxxxx.proxy.rlwy.net:12345`.
6. Connect with an RDP client using that hostname and port.

Default login in this demo image:
- Username: `root`
- Password: `root`

**Change the password before exposing it publicly.**

Do not use the normal `*.up.railway.app` HTTP domain as the RDP address. RDP requires Railway TCP Proxy.
