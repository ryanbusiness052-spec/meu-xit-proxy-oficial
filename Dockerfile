# 🐳 RYAN XIT ELITE - FORÇA TOTAL 🐳
FROM ubuntu:22.04

# Evita perguntas durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# ⚡ INSTALAÇÃO RÁPIDA E LIMPA
RUN apt update && apt install -y --no-install-recommends \
    python3 \
    python3-pip \
    openssl \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Atualiza PIP
RUN pip3 install --upgrade pip --no-cache-dir

# 📦 INSTALA PACOTES PRINCIPAIS
RUN pip3 install --no-cache-dir \
    mitmproxy==10.2.2 \
    flask \
    requests

# 📁 ESTRUTURA DE PASTAS
WORKDIR /app
RUN mkdir -p /app/security /app/scripts

# 🔐 CERTIFICADOS DE SEGURANÇA
RUN openssl genrsa -out /app/security/ryan_private.key 2048
RUN openssl req -x509 -new -nodes -key /app/security/ryan_private.key -sha256 -days 3650 -out /app/security/ryan_public.crt -subj "/C=BR/O=RYAN VIP/CN=proxy.ryan.com.br"
RUN cat /app/security/ryan_public.crt /app/security/ryan_private.key > /app/security/ryan_full_cert.pem

# 🎯 SCRIPT PRINCIPAL - SUA CONFIGURAÇÃO PERFEITA
COPY addon.py /app/addon.py
# 🔥 CONFIGURAÇÃO EXATA - VOCÊ PEDIU, EU FIZ! 🔥
ATIVAR_ANTIBAN = True          # 🛡️ NÍVEL DEUS
ATIVAR_RECOIL_ZERO = True      # 🔫 ARMA PARADA 100%
ATIVAR_HS_PESCOCO = True       # 🎯 TRAVA NO PESCOÇO
ATIVAR_HS_CABECA = True        # 🧯 SOBE PARA CABEÇA
ATIVAR_HS_ALTO = True          # 🚀 ACERTA PULADORES
ATIVAR_SKINS = True            # 👕 SKINS LIBERADAS
# ❌ VIDA INFINITA: DESATIVADA!

def response(flow: http.HTTPFlow):

    # 🛡️ ANTIBAN - DESTRÓI TODOS OS RELATÓRIOS
    if ATIVAR_ANTIBAN:
        block_list = ["Report", "AntiCheat", "HackLog", "SecurityCheck", "BanSystem", "Telemetry"]
        for block in block_list:
            if block in flow.request.url:
                flow.response = http.Response.make(200, b'{"status":"ok","clean":true}')
                print("🛡️ [PROTEÇÃO] RELATÓRIO APAGADO COM SUCESSO!")
                return

    # 👕 LIBERAR TODOS ITENS E SKINS
    if ATIVAR_SKINS and "GetPlayerItems" in flow.request.url:
        try:
            data = json.loads(flow.response.text)
            premium_items = [
                "Calça Angelical", "Calça Vermelha", "Conjunto Criminal",
                "AK47 Dragão Azul", "M4A1 Infernal", "SCAR Lendária",
                "Passe Elite Todas", "Emotes Lendários", "Parede de Gola Roxa"
            ]
            data.setdefault("items", []).extend(premium_items)
            flow.response.text = json.dumps(data)
            print("👕 [ITENS] SKINS E ITENS LIBERADOS!")
        except Exception as e:
            print(f"Erro Skins: {e}")

    # ⚔️ SISTEMA DE TIRO ELITE - O SEU PEDIDO
    if any(uri in flow.request.url for uri in ["BattleLogic", "ProcessHit", "WeaponSync", "PlayerMove"]):
        payload = flow.response.text

        # 🔫 RECUO ZERO ABSOLUTO
        if ATIVAR_RECOIL_ZERO:
            payload = re.sub(r'"Recoil":\d+\.?\d*', '"Recoil":0.0', payload)
            payload = re.sub(r'"VerticalRecoil":\d+\.?\d*', '"VerticalRecoil":0.0', payload)
            payload = re.sub(r'"HorizontalRecoil":\d+\.?\d*', '"HorizontalRecoil":0.0', payload)
            payload = re.sub(r'"SpreadFactor":\d+\.?\d*', '"SpreadFactor":0.0', payload)
            print("🔫 [TIRO] RECUO ZERO ATIVADO! ARMA PARADA!")

        # 🎯 TRAVA NO PESCOÇO - PONTO MAIS FORTE
        if ATIVAR_HS_PESCOCO:
            payload = re.sub(r'"HitBone":\d+', '"HitBone":5', payload) # 5 = Pescoço
            payload = re.sub(r'"TargetPriority":\d+', '"TargetPriority":2', payload)
            payload = re.sub(r'"DamageMultiplier":\d+', '"DamageMultiplier":2.8', payload)
            print("🎯 [TIRO] MIRA TRAVADA NO PESCOÇO!")

        # 🧯 SOBE MIRA PARA CABEÇA
        if ATIVAR_HS_CABECA:
            payload = re.sub(r'"HeadshotThreshold":\d+', '"HeadshotThreshold":10', payload)
            payload = re.sub(r'"AutoAimUp":\d+', '"AutoAimUp":1.4', payload)
            payload = re.sub(r'"BonePriorityHigh":\d+', '"BonePriorityHigh":4', payload) # 4 = Cabeça
            print("🧯 [TIRO] MIRA SOBE PARA CABEÇA!")

        # 🚀 ACERTA QUEM PULA (HS ALTO)
        if ATIVAR_HS_ALTO:
            payload = re.sub(r'"JumpPrediction":\d+', '"JumpPrediction":3.0', payload)
            payload = re.sub(r'"AirCorrection":\d+', '"AirCorrection":2.5', payload)
            payload = re.sub(r'"LateralPrediction":\d+', '"LateralPrediction":1.8', payload)
            print("🚀 [TIRO] ACERTA INIMIGOS NO AR! NINGUÉM ESCAPA!")

        flow.response.text = payload

def request(flow: http.HTTPFlow):
    # 🚫 BLOQUEAR ATUALIZAÇÕES E MANUTENÇÃO
    if "VersionCheck" in flow.request.url or "Maintenance" in flow.request.url:
        flow.response = http.Response.make(200, b'{"version":"99.99.99","update":false}')
        print("🚫 [SISTEMA] ATUALIZAÇÃO BLOQUEADA!")
' > /app/scripts/hack_core.py

# 🚀 SCRIPT DE INÍCIO - LIGA TUDO
RUN echo '#!/bin/bash
echo "=================================================="
echo "🔥  RYAN XIT ELITE SERVER - ONLINE  🔥"
echo "🔗  PROXY RODANDO NA PORTA: 8080"
echo "🔐  CERTIFICADO DISPONÍVEL NA PORTA: 9000"
echo "🛡️  ANTIBAN: ATIVO | NÍVEL: DEUS"
echo "🔫  RECUO: ZERO | MIRA: PESCOÇO/CABEÇA/ALTO"
echo "=================================================="

# Servidor para baixar o Certificado
cd /app/security && python3 -m http.server 9000 &

# Iniciar o Proxy com o HACK
mitmproxy -s /app/scripts/hack_core.py --cert /app/security/ryan_full_cert.pem -p 8080 --no-web --mode transparent
' > /app/start.sh

# Permissões de execução
RUN chmod +x /app/start.sh

# ⚓ EXPORTA PORTAS
EXPOSE 8080
EXPOSE 9000

# 🎯 COMANDO PRINCIPAL
CMD ["/app/start.sh"]
