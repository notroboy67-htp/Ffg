# Debian XFCE + XRDP for Railway

## Build locally
```bash
docker build -t xrdp .
docker run --rm -p 3389:3389 xrdp
```

## Railway
1. Deploy this repository using the Dockerfile.
2. In **Settings → Networking → TCP Proxy**, create a TCP proxy for internal port **3389**.
3. Railway will give you a public hostname and external port such as `something.proxy.rlwy.net:15140`.
4. Connect from an RDP client using that hostname and port.
5. Login:
   - Username: `root`
   - Password: `root`

Do not use the normal Railway HTTP domain as the RDP endpoint. RDP is raw TCP, so Railway's TCP Proxy is required.

If you configured an HTTP healthcheck, remove it unless you add a separate HTTP health service. Railway's TCP Proxy forwards raw TCP traffic to the internal service port.
