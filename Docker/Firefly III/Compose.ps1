#docker-compose -f docker-compose.yml up --force-recreate --detach
docker-compose -f docker-compose.yml up --detach

. "C:\Program Files\Mozilla Firefox\firefox.exe" -private-window http://localhost:80
. "C:\Program Files\Mozilla Firefox\firefox.exe" -private-window http://localhost:8081

