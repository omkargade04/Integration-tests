#!/bin/bash

# Start Docker containers
docker-compose up -d

# Wait for the database to be ready
echo '🟡 - Waiting for database to be ready...'
./scripts/wait-for-it.sh "localhost:5432" --timeout=60 --strict -- echo '🟢 - Database is ready!'

# Run Prisma migrations
echo "Running Prisma migrations..."
npx prisma migrate dev --name init || {
  echo "❌ - Prisma migrations failed!";
  docker-compose down;
  exit 1;
}

# Run tests
echo "Running tests..."
npm run test || {
  echo "❌ - Tests failed!";
  docker-compose down;
  exit 1;
}

# Shut down Docker containers
docker-compose down
