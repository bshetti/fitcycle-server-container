#!/bin/sh

until mysql -h "$MYSQL_SERVER" -u "$MYSQL_ID" -p"$MYSQL_PASSWORD" -e 'select 1'; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

# Apply database migrations
echo "Apply database migrations"
python manage.py migrate
exec "$@"

