FROM ubuntu:22.04
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt update && apt install -y --no-install-recommends \
    python3 \
    python3-pip \
    openssl \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir mitmproxy flask requests

COPY . /app/

RUN mkdir -p /app/security
RUN openssl genrsa -out /app/security/ryan_private.key 2048
RUN openssl req -x509 -new -nodes -key /app/security/ryan_private.key -sha256 -days 3650 -out /app/security/ryan_public.crt -subj "/C=BR/O=RYAN VIP/CN=proxy.ryan.com.br"
RUN cat /app/security/ryan_public.crt /app/security/ryan_private.key > /app/security/ryan_full_cert.pem

RUN echo '#!/bin/bash
echo "================================"
echo "RYAN ELITE SERVER - ONLINE"
echo "PROXY RODANDO NA PORTA: 8080"
echo "CERTIFICADO DISPONIVEL NA PORTA: 9000"
echo "🔫  RECUO: ZERO | MIRA: PESCOÇO/CABEÇA/ALTO"
echo "================================"
cd /app/security && python3 -m http.server 9000 &
mitmproxy -s /app/scripts/hack.py --cert /app/security/ryan_full_cert.pem -p 8080 --no-web
' > /app/start.sh

RUN chmod +x /app/start.sh

EXPOSE 8080 9000
CMD ["bash", "/app/start.sh"]
