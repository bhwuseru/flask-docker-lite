FROM python:3.12-slim

ENV TZ=Asia/Tokyo \
  PATH="/opt/venv/bin:$PATH"

ARG NODEJS_VERSION
ENV NODEJS_VERSION=${NODEJS_VERSION}

COPY supervisord.conf /etc/supervisord.conf

# パッケージ更新と依存のインストール
RUN apt-get update && apt-get install -y \
  bash \
  gcc \
  g++ \
  libffi-dev \
  libssl-dev \
  curl \
  sudo \
  supervisor \
  tzdata \
  locales \
  git \
  # Playwright のブラウザ実行に必要な依存パッケージを追加 
  libnss3 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libgbm1 \
  libasound2 \
  libxshmfence1 \
  libxss1 \
  libgtk-3-0 \
  libx11-xcb1 \
  libpangocairo-1.0-0 \
  fonts-liberation \
  libappindicator3-1 \
  libcups2 \
  xdg-utils && \
  # ロケール設定
  sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# nodejs インストール
RUN apt-get update && apt-get install -y \
  curl \
  gnupg \
  ca-certificates \
  dirmngr && \
  curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash - && \
  apt-get install -y nodejs

# npm 経由でyarnとplaywrightをインストール
RUN npm install -g yarn playwright \
  && playwright install --with-deps

# タイムゾーン設定
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone

# 仮想環境の作成とFlask + Gunicornインストール
RUN python -m venv /opt/venv && \
  /opt/venv/bin/pip install --upgrade pip && \
  /opt/venv/bin/pip install "flask>=3.0.0" gunicorn

# Supervisor 設定用ディレクトリ
RUN mkdir -p /etc/supervisor.d

# アプリケーション作業ディレクトリ
WORKDIR /app
COPY . /app

# Supervisor 起動（設定ファイルは後でマウントまたは COPY）
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]