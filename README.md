# docker-microcks
Microcks mocking eco-system running under docker.

Composed of : 
- Microcks App
- Keycloak (Auth)
- MongoDB
- Postman runtime

Requirements : 
- You must have Traefik v3 container runnning. 

You must add in the /etc/hosts the following configurations
- 127.0.0.1 microcks.local.io microcks-kc.local.io microcks-postman.local.io
