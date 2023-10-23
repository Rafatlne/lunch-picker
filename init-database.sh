#!/bin/bash
set -e
export PGPASSWORD="$POSTGRES_PASSWORD"

# Check if the user already exists
user_exists=$(psql -U "postgres" -tAc "SELECT 1 FROM pg_user WHERE usename = '$POSTGRES_USER'")
if [ -z "$user_exists" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';
EOSQL
fi

# Check if the database already exists
db_exists=$(psql -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -qw "$POSTGRES_DB" || echo "")
if [ -n "$db_exists" ]; then
  echo "Database $POSTGRES_DB already exists."
else
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "$POSTGRES_DB";
    ALTER DATABASE "$POSTGRES_DB" OWNER TO "$POSTGRES_USER";
    GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_DB" TO "$POSTGRES_USER";
EOSQL
fi
