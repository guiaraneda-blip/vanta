#!/bin/bash
# VANTA OS — Fix script para tools que fallaron en install.sh

# getJS
go install github.com/003random/getJS@latest 2>/dev/null && echo "[✓] getJS" || echo "[✗] getJS"

# subzy
go install github.com/PentestPad/subzy@latest 2>/dev/null && echo "[✓] subzy" || echo "[✗] subzy"

# anew
go install github.com/tomnomnom/anew@latest 2>/dev/null && echo "[✓] anew" || echo "[✗] anew"

# feroxbuster — binario directo
curl -sL https://github.com/epi052/feroxbuster/releases/latest/download/x86_64-linux-feroxbuster.zip \
    -o /tmp/ferox.zip && unzip -o /tmp/ferox.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/feroxbuster && echo "[✓] feroxbuster" || echo "[✗] feroxbuster"

# corsy — desde GitHub
pip3 install --break-system-packages git+https://github.com/s0md3v/Corsy.git 2>/dev/null && \
    echo "[✓] corsy" || echo "[✗] corsy"

ln -sf $HOME/go/bin/* /usr/local/bin/ 2>/dev/null
echo "Done"
