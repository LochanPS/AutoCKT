# syntax=docker/dockerfile:1

FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# System deps and KiCad 9 (CLI)
RUN apt-get update && apt-get install -y \
    software-properties-common curl git python3 python3-pip python3-venv ca-certificates gnupg \
    libgl1-mesa-glx libxrender1 libxrandr2 libxss1 libgconf-2-4 libxtst6 libxcomposite1 \
    libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 \
    libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    libatspi2.0-0 libdrm2 libgtk-3-0 libxkbcommon0 && \
    add-apt-repository -y ppa:kicad/kicad-dev-nightly && \
    apt-get update && apt-get install -y kicad && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# App setup
WORKDIR /app
COPY . /app
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -e .[dev]

EXPOSE 8501
CMD ["python3","-m","streamlit","run","app_streamlit.py","--server.headless","true","--server.port","8501","--server.address","0.0.0.0"]