#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

while !</dev/tcp/postgres-database/5432;
do sleep 1;
done

# Apply Django database migrations
echo "Applying Django database migrations..."
python manage.py migrate

# Start the Django development server
echo "Starting Django development server..."
python manage.py runserver 0.0.0.0:8000
