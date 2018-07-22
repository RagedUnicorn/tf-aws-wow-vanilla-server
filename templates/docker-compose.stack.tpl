version: '3.6'
services:
  wow-vanilla-database:
    image: ragedunicorn/mysql:1.0.2-stable
    volumes:
      - mysql_data:/var/lib/mysql
    secrets:
      - com.ragedunicorn.mysql.root_password
      - com.ragedunicorn.mysql.app_user
      - com.ragedunicorn.mysql.app_user_password
    healthcheck:
      test: ["CMD", "/docker-healthcheck.sh"]
      interval: 1m
      timeout: 10s
      retries: 3
    labels:
      com.ragedunicorn.mysql.environment: "prod"
      com.ragedunicorn.mysql.description: "MySQL"
  wow-vanilla-server:
    image: ragedunicorn/wow-vanilla:1.0.0-stable
    secrets:
      - com.ragedunicorn.mysql.app_user
      - com.ragedunicorn.mysql.app_user_password
    environment:
      - DATABASE_HOSTNAME=wow-vanilla-database
    ports:
      - "8085:8085"
      - "3724:3724"
    depends_on:
      - wow-vanilla-database
    stdin_open: true
    tty: true
    healthcheck:
      test: ["CMD", "/docker-healthcheck.sh"]
      interval: 1m
      timeout: 10s
      retries: 3
    labels:
      com.ragedunicorn.tomcat.environment: "prod"
      com.ragedunicorn.tomcat.description: "World of Warcraft Vanilla Server"
volumes:
  mysql_data: {}
secrets:
  com.ragedunicorn.mysql.root_password:
    external: true
  com.ragedunicorn.mysql.app_user:
    external: true
  com.ragedunicorn.mysql.app_user_password:
    external: true
