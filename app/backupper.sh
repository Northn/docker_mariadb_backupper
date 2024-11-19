#!/bin/sh

get_env_var_from_file() {
  var_name="$1"
  file_var_name="${var_name}_FILE"
  var_value=$(eval echo \$$var_name)
  file_var_value=$(eval echo \$$file_var_name)

  if [ -n "$file_var_value" ]; then
    var_value=$(cat "$file_var_value")
  fi

  echo "$var_value"
}

# Load database credentials and backup directory from environment variables or files
DB_USER=$(get_env_var_from_file "DB_USER")
DB_PASSWORD=$(get_env_var_from_file "DB_PASSWORD")
DB_NAME=$(get_env_var_from_file "DB_NAME")
DB_HOST=$(get_env_var_from_file "DB_HOST")
DB_PORT=$(get_env_var_from_file "DB_PORT")

# Dump the database and compress it into a zip file
DUMP_FILE="/backups/${DB_NAME}_backup_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).sql"

if mariadb-dump \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    "$DB_NAME" > "$DUMP_FILE"; then
  zip -j "${DUMP_FILE}.zip" "$DUMP_FILE" && rm "$DUMP_FILE"
else
  echo "Error: mariadb-dump failed for database: $DB_NAME"
  exit 1
fi
