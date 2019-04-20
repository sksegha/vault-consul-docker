# Vault + Consul in Docker

Spins up a vault container with consul as its backend storage.
This vault setup can easily be accessed on the port 8200

http://127.0.0.1:8200


## Usage

## Initial Run 

1. Start services: `docker-compose up -d'
2. Set up vault:     `./scripts/setup.sh`

Data will be persisted in the `data` directory.


#### After the first run

1. Start services: `docker-compose up -d`
2. Unseal vault:   `scripts/unseal.sh`


#### clean up data/installation

1. Stop services: `docker-compose down`
2. Wipe data: `scripts/clean.sh`

The last command will wipe out all data, such that when you restart services you will need to run setup.sh again and data is gone.
