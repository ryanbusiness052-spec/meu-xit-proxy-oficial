from mitmproxy import http
import json
import re

# 🔥 SUAS CONFIGURAÇÕES EXATAS 🔥
ANTIBAN = True          # 🛡️ NÍVEL DEUS
RECOIL_ZERO = True      # 🔫 ARMA PARADA 100%
HS_PESCOCO = True       # 🎯 TRAVA NO PESCOÇO
HS_CABECA = True        # 🧯 SOBE PARA CABEÇA
HS_ALTO = True          # 🚀 ACERTA PULADORES
SKINS = True            # 👕 SKINS LIBERADAS
# ❌ VIDA INFINITA: DESATIVADA!

def response(flow: http.HTTPFlow):

    # 🛡️ ANTIBAN - DESTRÓI TODOS OS RELATÓRIOS
    if ANTIBAN:
        block_list = ["Report", "AntiCheat", "HackLog", "SecurityCheck", "BanSystem", "Telemetry"]
        for block in block_list:
            if block in flow.request.url:
                flow.response = http.Response.make(200, b'{"status":"ok","clean":true}')
                return

    # 👕 LIBERAR TODOS ITENS E SKINS
    if SKINS and "GetPlayerItems" in flow.request.url:
        try:
            data = json.loads(flow.response.text)
            premium_items = [
                "Calça Angelical", "Calça Vermelha", "Conjunto Criminal",
                "AK47 Dragão Azul", "M4A1 Infernal", "SCAR Lendária",
                "Passe Elite Todas", "Emotes Lendários", "Parede de Gola Roxa"
            ]
            data.setdefault("items", []).extend(premium_items)
            flow.response.text = json.dumps(data)
        except:
            pass

    # ⚔️ SISTEMA DE TIRO ELITE - O SEU PEDIDO
    if any(uri in flow.request.url for uri in ["BattleLogic", "ProcessHit", "WeaponSync", "PlayerMove"]):
        payload = flow.response.text

        # 🔫 RECUO ZERO ABSOLUTO
        if RECOIL_ZERO:
            payload = re.sub(r'"Recoil":\d+\.?\d*', '"Recoil":0.0', payload)
            payload = re.sub(r'"VerticalRecoil":\d+\.?\d*', '"VerticalRecoil":0.0', payload)
            payload = re.sub(r'"HorizontalRecoil":\d+\.?\d*', '"HorizontalRecoil":0.0', payload)
            payload = re.sub(r'"SpreadFactor":\d+\.?\d*', '"SpreadFactor":0.0', payload)

        # 🎯 TRAVA NO PESCOÇO - PONTO MAIS FORTE
        if HS_PESCOCO:
            payload = re.sub(r'"HitBone":\d+', '"HitBone":5', payload) # 5 = Pescoço
            payload = re.sub(r'"TargetPriority":\d+', '"TargetPriority":2', payload)
            payload = re.sub(r'"DamageMultiplier":\d+', '"DamageMultiplier":2.8', payload)

        # 🧯 SOBE MIRA PARA CABEÇA
        if HS_CABECA:
            payload = re.sub(r'"HeadshotThreshold":\d+', '"HeadshotThreshold":10', payload)
            payload = re.sub(r'"AutoAimUp":\d+', '"AutoAimUp":1.4', payload)
            payload = re.sub(r'"BonePriorityHigh":\d+', '"BonePriorityHigh":4', payload) # 4 = Cabeça

        # 🚀 ACERTA QUEM PULA (HS ALTO)
        if HS_ALTO:
            payload = re.sub(r'"JumpPrediction":\d+', '"JumpPrediction":3.0', payload)
            payload = re.sub(r'"AirCorrection":\d+', '"AirCorrection":2.5', payload)
            payload = re.sub(r'"LateralPrediction":\d+', '"LateralPrediction":1.8', payload)

        flow.response.text = payload

def request(flow: http.HTTPFlow):
    # 🚫 BLOQUEAR ATUALIZAÇÕES E MANUTENÇÃO
    if "VersionCheck" in flow.request.url or "Maintenance" in flow.request.url:
        flow.response = http.Response.make(200, b'{"version":"99.99.99","update":false}')
