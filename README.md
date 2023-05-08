# Tailscale Subnet Router in Docker #

This repository is used to create a [Tailscale subnet router](https://tailscale.com/kb/1019/subnets/) as a Docker container. It'll allow nodes on your tailnet to connect to devices relative to this host. 

# Basic usage: #
```bash
git clone https://github.com/prossouw79/tailscale-subnet-router-docker.git
cd tailscale-subnet-router-docker
cp .env.template .env
nano .env
# fill in details...
docker-compose up -d --build
docker-compose logs -f
```

Go to  [Tailscale Admin Console](https://login.tailscale.com/admin/machines) and allow route settings exposed by this container.

# Parameters #
The functionality is controlled through environment variables:
```bash
TAILSCALE_AUTH_KEY=tskey-auth-example-key-content
TAILSCALE_HOSTNAME=hostname-you-want-in-tailscale-console
TAILSCALE_TAG=tag-to-assign
TAILSCALE_ADVERTISE_CIDR=192.168.1.0/24
```

# Security #
Ensure you appropriately constrain access inside your tailnet using ACLs and Tags. Running this inside your home network with your home CIDR will expose it to the entire tailnet. It is the responsibility is on the user to use tailscale's excellent tooling to make sure this does not expose any ports/services/machines that aren't meant to be exposed.