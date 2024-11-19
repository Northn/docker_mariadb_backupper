#!/bin/sh

# Strip the leading and trailing quotation marks if present
CRON_INTERVAL=$(echo "$CRON_INTERVAL" | sed 's/^"//;s/"$//')

if [ -z "$CRON_INTERVAL" ]; then
  echo "Error: CRON_INTERVAL is not set"
  exit 1
fi

echo "CRON_INTERVAL is set to: $CRON_INTERVAL"

# Function to export environment variables, including _FILE alternatives
export_env_var() {
  var_name="$1"
  file_var_name="${var_name}_FILE"
  var_value=$(eval echo \$$var_name)
  file_var_value=$(eval echo \$$file_var_name)

  if [ -n "$file_var_value" ]; then
    var_value=$file_var_value
  fi

  echo "$var_name=$var_value"
}

# Export necessary environment variables to the cron job entry
{
  export_env_var "DB_HOST"
  export_env_var "DB_PORT"
  export_env_var "DB_USER"
  export_env_var "DB_PASSWORD"
  export_env_var "DB_NAME"
  echo "$CRON_INTERVAL /app/backupper.sh"
} | crontab -u backupper -

# Check if the crontab command succeeded
if [ $? -ne 0 ]; then
  echo "Error: Failed to install crontab"
  exit 1
fi

cron -f
