# 🐳 DOCKERFILE LIMPO E CORRETO 🐳
FROM ubuntu:22.04
WORKDIR /app

# Configurações
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Instalar dependências
RUN apt update && apt install -y --no-install-recommends \
    python3 \
    python3-pip \
    openssl \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir mitmproxy flask requests

# 📁 AGORA SÓ COPIAMOS OS ARQUIVOS DO GITHUB! SEM CÓDIGO AQUI!
COPY . /app/

# 🔐 GERAR CERTIFICADOS (AQUI PODE, SÃO COMANDOS DO DOCKER)
RUN mkdir -p /app/security
RUN openssl genrsa -out /app/security/ryan_private.key 2048
RUN openssl req -x509 -new -nodes -key /app/security/ryan_private.key -sha256 -days 3650 -out /app/security/ryan_public.crt -subj "/C=BR/O=RYAN VIP/CN=proxy.ryan.com.br"
RUN cat /app/security/ryan_public.crt /app/security/ryan_private.key > /app/security/ryan_full_cert.pem

# 🚀 SCRIPT DE INÍCIO
RUN echo '#!/bin/bash
>>> echo "================================"
    echo "🔥 RYAN ELITE SERVER - ONLINE 🔥"
echo "🔗  PROXY RODANDO NA PORTA: 8080"
echo "🔐  CERTIFICADO DISPONÍVEL NA PORTA: 9000"
echo "🛡️  ANTIBAN: ATIVO | NÍVEL: DEUS"
echo "🔫  RECUO: ZERO | MIRA: PESCOÇO/CABEÇA/ALTO"
echo "=================================================="

# Servidor para baixar o Certificado
cd /app/security && python3 -m http.server 9000 &

# Iniciar o Proxy chamando o arquivo que COPIAMOS do GitHub
mitmproxy -s /app/scripts/hack.py --cert /app/security/ryan_full_cert.pem -p 8080 --no-web
' > /app/start.sh

RUN chmod +x /app/start.sh

EXPOSE 8080 9000
CMD ["/app/start.sh"]
