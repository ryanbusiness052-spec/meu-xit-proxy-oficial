# 🐳 DOCKERFILE OFICIAL - RYAN EDITION 🐳
FROM ubuntu:22.04
WORKDIR /app

# ⚡ INSTALAÇÃO RÁPIDA DE TODAS AS DEPENDÊNCIAS
RUN apt update -y && apt upgrade -y
RUN apt install -y python3-pip openssl net-tools curl nano
RUN pip3 install --upgrade pip
RUN pip3 install mitmproxy flask requests

# 🔐 CRIA ESTRUTURA E CERTIFICADOS
RUN mkdir -p /app/security /app/scripts /app/certs
RUN openssl genrsa -out /app/security/xit_key.pem 2048
RUN openssl req -x509 -new -nodes -key /app/security/xit_key.pem -sha256 -days 3650 -out /app/security/xit_cert.crt -subj "/C=BR/O=RYAN/CN=proxy"
RUN cat /app/security/xit_cert.crt /app/security/xit_key.pem > /app/security/full_cert.pem

# 🎯 SCRIPT PRINCIPAL - SUA CONFIGURAÇÃO PERFEITA
RUN echo '
from mitmproxy import http
import json, re

# 🔥 CONFIGURAÇÃO EXATA QUE VOCÊ PEDIU 🔥
ANTIBAN = True          # 🛡️ ANTIBAN MÁXIMO
RECOIL_ZERO = True      # 🔫 RECUO ZERO
HS_PESCOCO = True       # 🎯 100% PESCOÇO
HS_CABECA = True        # 🧠 CABEÇA
HS_ALTO = True          # 🚀 EM PULADORES
SKINS = True            # 👕 SKINS
# ❌ VIDA INFINITA REMOVIDA!

def response(flow):
    # 🛡️ ANTIBAN - LIMPA TUDO
    if ANTIBAN and any(x in flow.request.url for x in ["Report", "AntiCheat", "Log", "Ban"]):
        flow.response = http.Response.make(200, b"{\"ok\":1}")
        print("🛡️ ANTIBAN: LIMPO!")
        return

    # 👕 SKINS
    if SKINS and "GetPlayerItems" in flow.request.url:
        try:
            d = json.loads(flow.response.text)
            d.setdefault("items", []).extend(["Calça Angelical", "Criminal", "AK47 Dragão", "Passe Elite"])
            flow.response.text = json.dumps(d)
            print("👕 SKINS LIBERADAS!")
        except: pass

    # ⚔️ SISTEMA DE TIRO ELITE
    if any(x in flow.request.url for x in ["BattleLogic", "ProcessHit", "Weapon"]):
        t = flow.response.text
        
        if RECOIL_ZERO:
            t = re.sub(r'"Recoil":\d+\.?\d*', '"Recoil":0.0', t)
            t = re.sub(r'"Spread":\d+\.?\d*', '"Spread":0.0', t)
        
        if HS_PESCOCO:
            t = re.sub(r'"BoneTarget":\d+', '"BoneTarget":5', t) # 5 = PESCOÇO
            t = re.sub(r'"HitMultiplier":\d+', '"HitMultiplier":3', t)
        
        if HS_CABECA:
            t = re.sub(r'"BoneTargetHigh":\d+', '"BoneTargetHigh":4', t) # 4 = CABEÇA
            t = re.sub(r'"AimUpFactor":\d+', '"AimUpFactor":1.5', t)
        
        if HS_ALTO:
            t = re.sub(r'"JumpCorrection":\d+', '"JumpCorrection":2.5', t)
            t = re.sub(r'"AirAimAssist":\d+', '"AirAimAssist":3', t)

        flow.response.text = t
        print("💥 TIRO: RECUO 0 + HS PESCOÇO/CABEÇA/ALTO!")
' > /app/scripts/hack.py

# 🚀 SCRIPT DE INÍCIO
RUN echo '#!/bin/bash
echo "🔥 RYAN XIT ELITE - ONLINE 🔥"
cd /app/security && python3 -m http.server 9000 &
mitmproxy -s /app/scripts/hack.py --cert /app/security/full_cert.pem -p 8080 --no-web
' > /app/start.sh && chmod +x /app/start.sh

# ⚡ COMANDO PRINCIPAL
CMD ["/app/start.sh"]
