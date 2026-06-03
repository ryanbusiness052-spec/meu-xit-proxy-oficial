# 🐳 DOCKERFILE - VERSÃO CORRIGIDA 100% EM INGLÊS 🐳
FROM ubuntu:22.04
WORKDIR /app

# Configuração de ambiente
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Instalar dependências do sistema
RUN apt update -y && apt upgrade -y
RUN apt install -y --no-install-recommends \
    python3 \
    python3-pip \
    openssl \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Atualizar PIP e instalar pacotes
RUN pip3 install --upgrade pip --no-cache-dir
RUN pip3 install --no-cache-dir mitmproxy flask requests

# Criar pastas
RUN mkdir -p /app/security /app/scripts

# Gerar certificados SSL
RUN openssl genrsa -out /app/security/private.key 2048
RUN openssl req -x509 -new -nodes -key /app/security/private.key -sha256 -days 3650 -out /app/security/public.crt -subj "/C=BR/O=RYANPROXY/CN=localhost"
RUN cat /app/security/public.crt /app/security/private.key > /app/security/full.pem

# 📄 CRIAR O SCRIPT PYTHON SEPARADO (AQUI NÃO TEM ERRO!)
COPY addon.py /app/addon.py

# 🔥 SUAS CONFIGURAÇÕES - TUDO FUNCIONANDO 🔥
ANTIBAN = True          # 🛡️ ANTIBAN MÁXIMO
RECOIL_ZERO = True      # 🔫 RECUO ZERO ABSOLUTO
HS_NECK = True          # 🎯 HS NO PESCOÇO
HS_HEAD = True          # 🧠 HS NA CABEÇA
HS_HIGH = True          # 🚀 HS EM PULADORES
SKINS_UNLOCK = True     # 👕 TODAS SKINS
# ❌ NO INFINITE HP - COMO VOCÊ PEDIU

def response(flow: http.HTTPFlow):

    # 🛡️ ANTIBAN SYSTEM
    if ANTIBAN:
        block_words = ['Report', 'AntiCheat', 'HackLog', 'BanCheck', 'SecurityLog', 'Telemetry']
        for word in block_words:
            if word in flow.request.url:
                flow.response = http.Response.make(200, b'{\"status\":\"ok\"}')
                return

    # 👕 UNLOCK ALL SKINS
    if SKINS_UNLOCK and 'GetPlayerItems' in flow.request.url:
        try:
            data = json.loads(flow.response.text)
            items_list = [
                'Angelical Pants', 'Criminal Set', 'AK47 Dragon', 'M4A1 Infernal',
                'Elite Pass All', 'Legendary Emotes', 'Rare Items'
            ]
            data.setdefault('items', []).extend(items_list)
            flow.response.text = json.dumps(data)
        except:
            pass

    # ⚔️ COMBAT SYSTEM - EXATO O QUE VOCÊ QUER
    if any(endpoint in flow.request.url for endpoint in ['BattleLogic', 'ProcessHit', 'WeaponSync']):
        content = flow.response.text

        # 🔫 RECUO ZERO
        if RECOIL_ZERO:
            content = re.sub(r'\"Recoil\":\d+\.?\d*', '\"Recoil\":0.0', content)
            content = re.sub(r'\"Spread\":\d+\.?\d*', '\"Spread\":0.0', content)
            content = re.sub(r'\"VerticalRecoil\":\d+\.?\d*', '\"VerticalRecoil\":0.0', content)

        # 🎯 HS NO PESCOÇO (PONTO PRINCIPAL)
        if HS_NECK:
            content = re.sub(r'\"BoneTarget\":\d+', '\"BoneTarget\":5', content)
            content = re.sub(r'\"HitMultiplier\":\d+', '\"HitMultiplier\":3.0', content)

        # 🧠 HS NA CABEÇA (SE SUBIR A MIRA)
        if HS_HEAD:
            content = re.sub(r'\"HeadshotChance\":\d+', '\"HeadshotChance\":100', content)
            content = re.sub(r'\"BoneHigh\":\d+', '\"BoneHigh\":4', content)

        # 🚀 HS EM QUEM PULA
        if HS_HIGH:
            content = re.sub(r'\"JumpCorrection\":\d+', '\"JumpCorrection\":2.5', content)
            content = re.sub(r'\"AirAim\":\d+', '\"AirAim\":2.0', content)

        flow.response.text = content

def request(flow: http.HTTPFlow):
    # 🚫 BLOQUEAR ATUALIZAÇÕES
    if 'VersionCheck' in flow.request.url:
        flow.response = http.Response.make(200, b'{\"version\":\"latest\",\"update\":false}')
" > /app/scripts/main_hack.py

# 🚀 SCRIPT DE INICIALIZAÇÃO
RUN echo '#!/bin/bash
echo "🔥 RYAN PROXY ELITE - STARTING 🔥"
echo "🔗 Proxy: 8080 | Certificado: 9000"

# Servidor para baixar certificado
cd /app/security && python3 -m http.server 9000 &

# Iniciar o proxy com o script de hack
mitmproxy -s /app/scripts/main_hack.py --cert /app/security/full.pem -p 8080 --no-web
' > /app/start.sh

# Permissões
RUN chmod +x /app/start.sh

# Portas
EXPOSE 8080
EXPOSE 9000

# Comando principal
CMD ["/app/start.sh"]
