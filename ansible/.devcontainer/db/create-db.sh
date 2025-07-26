#!/bin/bash
set -e

DB_NAME="${POSTGRES_DB:-sample_db}"
DB_TEST_NAME="${POSTGRES_DB}_test"
DB_USER="${POSTGRES_USER:-user}"
DB_PASSWORD="${POSTGRES_PASSWORD:-password}"

export PGPASSWORD="$DB_PASSWORD"

# 本番DBが存在しなければ作成
psql -U "$DB_USER" -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 || \
psql -U "$DB_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\" ENCODING 'UTF8';"

# テストDBが存在しなければ作成
psql -U "$DB_USER" -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_TEST_NAME'" | grep -q 1 || \
psql -U "$DB_USER" -d postgres -c "CREATE DATABASE \"$DB_TEST_NAME\" ENCODING 'UTF8';"

# 権限付与（失敗しても問題なし）
psql -U "$DB_USER" -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$DB_NAME\" TO \"$DB_USER\";" || true
psql -U "$DB_USER" -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$DB_TEST_NAME\" TO \"$DB_USER\";" || true

echo " データベース $DB_NAME / $DB_TEST_NAME の作成と権限付与完了"