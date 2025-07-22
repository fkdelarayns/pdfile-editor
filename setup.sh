export WWWUSER=${WWWUSER:-$UID}
export WWWGROUP=${WWWGROUP:-$(id -g)}

# Copy environment variables
if ! [ -f .env ]; then
    cp .env.example .env;
fi

# Copy docker-compose override configuration
if ! [ -f docker-compose.override.yml ]; then
    cp docker-compose.dev.yml docker-compose.override.yml;
fi

# Build docker image
docker-compose build --no-cache

# Install PHP packages
docker-compose run $1 ${WWWUSER}:${WWWGROUP} composer install

# Start services
./vendor/bin/sail down
./vendor/bin/sail up -d

# Generate application key
./vendor/bin/sail artisan key:generate

# Stop service for setup
./vendor/bin/sail stop
