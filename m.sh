#!/bin/bash

# IP Logger _ @MR_MAMAD_TM

clear
echo "══════════════════════════════════════════════════════════════════════"
echo "█▄░▄█ █▀▀▄"
echo "█░█░█ █▐█▀"
echo "▀░░░▀ ▀░▀▀"
echo "█▄░▄█ ▄▀▄ █▄░▄█ ▄▀▄ █▀▄"
echo "█░█░█ █▀█ █░█░█ █▀█ █░█"
echo "▀░░░▀ ▀░▀ ▀░░░▀ ▀░▀ ▀▀░"
echo "▀█▀ █▄░▄█"
echo "░█░ █░█░█"
echo "░▀░ ▀░░░▀"
echo "══════════════════════════════════════════════════════════════════════"
echo "🚀 IP Logger _ @MR_MAMAD_TM"
echo "══════════════════════════════════════════════════════════════════════"
echo ""

# Install prerequisites
echo "📦 Checking prerequisites..."
pkg install -y python openssh termux-api 2>/dev/null

echo "📦 Installing Flask... (please wait)"
pip install flask flask-cors requests -q

# Project folder
mkdir -p ~/ip_logger_serveo
cd ~/ip_logger_serveo

# HTML template
mkdir -p templates
cat > templates/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mr Mamad TM - IP Logger</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', Tahoma, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
            max-width: 550px;
            width: 90%;
            text-align: center;
        }
        .ascii-art {
            font-family: monospace;
            color: #302b63;
            font-size: 12px;
            line-height: 1.3;
            margin-bottom: 15px;
            background: #f0f0f0;
            padding: 10px;
            border-radius: 10px;
            white-space: pre;
        }
        h1 { color: #302b63; font-size: 1.8em; margin-bottom: 10px; }
        .subtitle { color: #666; font-size: 14px; margin-bottom: 20px; }
        .ip-box {
            background: #f0f0f0;
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
        }
        .ip-address {
            font-size: 28px;
            font-weight: bold;
            color: #302b63;
            font-family: monospace;
            direction: ltr;
            word-break: break-all;
        }
        .info { color: #666; font-size: 14px; margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; }
        .badge {
            background: #302b63;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            display: inline-block;
            margin-top: 20px;
        }
        .channel-link {
            display: inline-block;
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 14px;
            margin: 5px;
            transition: all 0.3s;
        }
        .channel-link.telegram { background: #0088cc; }
        .channel-link.youtube { background: #FF0000; }
        .channel-link:hover { transform: scale(1.05); opacity: 0.9; }
        .loading {
            display: inline-block;
            width: 50px;
            height: 50px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #302b63;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .footer-ascii { font-family: monospace; color: #888; font-size: 10px; margin-top: 20px; }
        .links-section { margin-top: 15px; padding: 15px; background: #f8f8f8; border-radius: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="ascii-art">
█▄░▄█ █▀▀▄
█░█░█ █▐█▀
▀░░░▀ ▀░▀▀
█▄░▄█ ▄▀▄ █▄░▄█ ▄▀▄ █▀▄
█░█░█ █▀█ █░█░█ █▀█ █░█
▀░░░▀ ▀░▀ ▀░░░▀ ▀░▀ ▀▀░
▀█▀ █▄░▄█
░█░ █░█░█
░▀░ ▀░░░▀
        </div>
        <h1>🌐 Welcome</h1>
        <p class="subtitle">IP Logger</p>
        <div class="ip-box">
            <div id="loading" class="loading"></div>
            <div id="ipDisplay" style="display: none;">
                <p>Your IP Address:</p>
                <p class="ip-address" id="ip"></p>
                <p id="time" style="color: #999; margin-top: 10px;"></p>
            </div>
        </div>
        <div class="badge">✅ Information Logged</div>
        <div class="info"><p>💍💍💍</p><p>⚡⚡⚡</p></div>
        <div class="links-section">
            <a href="https://t.me/mr_mamad_tm" target="_blank" class="channel-link telegram">📱 Telegram: @mr_mamad_tm</a><br>
            <a href="https://youtube.com/@mr_mamad_tm" target="_blank" class="channel-link youtube">▶️ YouTube: @mr_mamad_tm</a>
        </div>
        <div class="footer-ascii">🥳 MMD IP Logger 🥳</div>
    </div>
    <script>
        fetch('/get-ip')
            .then(res => res.json())
            .then(data => {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('ipDisplay').style.display = 'block';
                document.getElementById('ip').innerText = data.ip;
                const now = new Date();
                document.getElementById('time').innerText = `Time: ${now.toLocaleTimeString('en-US')}`;
            })
            .catch(() => {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('ipDisplay').style.display = 'block';
                document.getElementById('ip').innerText = 'Error getting IP';
            });
    </script>
</body>
</html>
EOF

# Python Flask app (clean logs)
cat > app.py << 'EOF'
import logging
from flask import Flask, render_template, jsonify, request
import datetime
import json
import threading
import time
import subprocess
import requests
import os
import sys

# Disable Flask and Werkzeug logs
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

app = Flask(__name__)

ASCII_ART = """
█▄░▄█ █▀▀▄
█░█░█ █▐█▀
▀░░░▀ ▀░▀▀
█▄░▄█ ▄▀▄ █▄░▄█ ▄▀▄ █▀▄
█░█░█ █▀█ █░█░█ █▀█ █░█
▀░░░▀ ▀░▀ ▀░░░▀ ▀░▀ ▀▀░
▀█▀ █▄░▄█
░█░ █░█░█
░▀░ ▀░░░▀
"""

CHANNEL_LINKS = """
📱 Telegram: https://t.me/mr_mamad_tm
▶️ YouTube: https://youtube.com/@mr_mamad_tm
"""

def get_location(ip):
    try:
        if ip in ['127.0.0.1', 'localhost']:
            return "Local"
        url = f"http://ip-api.com/json/{ip}"
        response = requests.get(url, timeout=3)
        data = response.json()
        if data.get('status') == 'success':
            return f"{data.get('city', 'Unknown')}, {data.get('country', 'Unknown')}"
        return "Unknown"
    except:
        return "Error"

def log_to_termux(ip, user_agent, location):
    timestamp = datetime.datetime.now().strftime("%H:%M:%S")
    
    os.system('clear')

    print("══════════════════════════════════════════════════════════════════════")

    print(ASCII_ART)

    print(CHANNEL_LINKS)

    print("══════════════════════════════════════════════════════════════════════")

    print(f"🔔 Time: {timestamp}")

    print(f"🌍 New IP: {ip}")

    print(f"📍 Location: {location}")

    print(f"📱 Browser: {user_agent[:70]}...")

    print("══════════════════════════════════════════════════════════════════════")

    print("\007", end='', flush=True)

def start_serveo():
    time.sleep(2)
    print("📡 Creating public URL with Serveo...")
    try:
        process = subprocess.Popen(
            ["ssh", "-o", "StrictHostKeyChecking=no", "-R", "80:localhost:5000", "serveo.net"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        for line in process.stdout:
            if "Forwarding HTTP traffic from" in line:
                url = line.split("from")[-1].strip()
                print(f"\n🔗 Public URL: {url}")
                print("📱 Share this link with anyone\n")
    except Exception as e:
        print(f"❌ Error: {e}")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/get-ip')
def get_ip():
    client_ip = request.remote_addr
    if request.headers.get('X-Forwarded-For'):
        client_ip = request.headers.get('X-Forwarded-For').split(',')[0]
    user_agent = request.headers.get('User-Agent', 'Unknown')
    location = get_location(client_ip)
    log_to_termux(client_ip, user_agent, location)
    return jsonify({
        'ip': client_ip,
        'location': location,
        'time': datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    })

if __name__ == '__main__':
    os.system('clear')
    print("══════════════════════════════════════════════════════════════════════")
    print(ASCII_ART)
    print(CHANNEL_LINKS)
    print("══════════════════════════════════════════════════════════════════════")
    print("\n🚀 IP Logger is Ready - Mr Mamad TM")
    print("📡 Starting services...\n")
    
    threading.Thread(target=start_serveo, daemon=True).start()
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)
EOF

# Clean run script
cat > run.sh << 'EOF'
#!/bin/bash
clear
echo "══════════════════════════════════════════════════════════════════════"
echo "█▄░▄█ █▀▀▄"
echo "█░█░█ █▐█▀"
echo "▀░░░▀ ▀░▀▀"
echo "█▄░▄█ ▄▀▄ █▄░▄█ ▄▀▄ █▀▄"
echo "█░█░█ █▀█ █░█░█ █▀█ █░█"
echo "▀░░░▀ ▀░▀ ▀░░░▀ ▀░▀ ▀▀░"
echo "▀█▀ █▄░▄█"
echo "░█░ █░█░█"
echo "░▀░ ▀░░░▀"
echo "══════════════════════════════════════════════════════════════════════"
echo "🚀 IP Logger - @MR_MAMAD_TM"
echo "══════════════════════════════════════════════════════════════════════"
echo ""

cd ~/ip_logger_serveo
python app.py
EOF

chmod +x run.sh

# Serveo manual script
cat > serveo.sh << 'EOF'
#!/bin/bash
echo "🔗 Creating Serveo tunnel..."
ssh -R 80:localhost:5000 serveo.net 2>/dev/null | grep "Forwarding HTTP traffic from"
EOF
chmod +x serveo.sh

# Completion message
clear
echo "══════════════════════════════════════════════════════════════════════"
echo "█▄░▄█ █▀▀▄"
echo "█░█░█ █▐█▀"
echo "▀░░░▀ ▀░▀▀"
echo "█▄░▄█ ▄▀▄ █▄░▄█ ▄▀▄ █▀▄"
echo "█░█░█ █▀█ █░█░█ █▀█ █░█"
echo "▀░░░▀ ▀░▀ ▀░░░▀ ▀░▀ ▀▀░"
echo "▀█▀ █▄░▄█"
echo "░█░ █░█░█"
echo "░▀░ ▀░░░▀"
echo "══════════════════════════════════════════════════════════════════════"
echo "✅ INSTALLATION COMPLETE!"
echo "══════════════════════════════════════════════════════════════════════"
echo ""
echo "📱 Channel: @mr_mamad_tm"
echo "📱 Telegram: https://t.me/mr_mamad_tm"
echo "▶️ YouTube: https://youtube.com/@mr_mamad_tm"
echo ""
echo "📌 TO RUN:"
echo "   bash run.sh"
echo ""
echo "══════════════════════════════════════════════════════════════════════"
echo "𝙼𝚁_𝙼𝙰𝙼𝙰𝙳_𝚃𝙼"
echo "══════════════════════════════════════════════════════════════════════"
