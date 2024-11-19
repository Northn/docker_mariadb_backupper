FROM mariadb:lts

# Install cron and zip
RUN apt-get update && apt-get install -y cron zip

# Create a user to run backupper script as non-root user
RUN useradd backupper

# Setup backupper starter scripts
WORKDIR /app
COPY app .
RUN chmod +x docker-entrypoint.sh
RUN chmod +x backupper.sh

# Setup default port to connect to database
# Note that DB_HOST shouldn't be set here to 'localhost' because we're running under container and can't have own database instance
ENV DB_PORT 3306

ENTRYPOINT ["/app/docker-entrypoint.sh"]
