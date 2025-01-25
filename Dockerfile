FROM debian:12-slim



RUN <<EOF

apt-get update
apt-get install -y --no-install-recommends socat curl gpg lsb-release ca-certificates
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg |  gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/cloudflare-client.list
apt-get update
apt-get purge -y --remove curl lsb-release
apt-get install -y --no-install-recommends cloudflare-warp

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

VOLUME [ "/var/lib/cloudflare-warp" ]

EXPOSE 40000
COPY --link entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
