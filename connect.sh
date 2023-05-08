#!/bin/bash
set -e

if [[ -z "${TAILSCALE_AUTH_KEY}" ]]; then
  echo "Unset environment variable: TAILSCALE_AUTH_KEY"
  exit 1
fi

if [[ -z "${TAILSCALE_HOSTNAME}" ]]; then
  echo "Unset environment variable: TAILSCALE_HOSTNAME"
  exit 1
fi

if [[ -z "${TAILSCALE_TAG}" ]]; then
  echo "Unset environment variable: TAILSCALE_TAG"
  exit 1
fi

if [[ -z "${TAILSCALE_ADVERTISE_CIDR}" ]]; then
  echo "Unset environment variable: TAILSCALE_ADVERTISE_CIDR"
  exit 1
fi

ts_state=/var/lib/tailscale_state/tailscale.state

echo "Starting tailscale daemon with statefile: $ts_state "
tailscaled --state $ts_state &

sleep 3

has_ip=0

while [ $has_ip -ne 1 ]; do
  echo "Checking if already assigned IP..."
  ts_ip=$(tailscale ip 2>&1 | head -n 1)

  if [[ $ts_ip = 100* ]]; then
    echo "Authenticated Tailscale IP: $ts_ip"
    has_ip=1
    break
  fi

  sleep 10
  
  echo "Authenticating with tailnet..."
  tailscale up \
    --authkey=$TAILSCALE_AUTH_KEY \
    --hostname=$TAILSCALE_HOSTNAME \
    --advertise-tags=tag:$TAILSCALE_TAG \
    --advertise-routes="$TAILSCALE_ADVERTISE_CIDR"
done

tailscale netcheck

sleep infinity