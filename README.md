# grpc-health-check-traefik

grpc health check with traefik and datadog private location setup

## Services

- Health check server (go), mapped with tcp :3333
- traefik 2.2, mapped with tcp :80
- datadog synthetics-private-location-worker

## How to get started

- Create a private location in datadog and download the config `.json` file.
- Replace the docker compose file with path to downloaded config file.

```
  synthetics-private-location-worker:
    image: datadog/synthetics-private-location-worker:latest
    volumes:
        - <PATH_TO_CONFIG_JSON>:/etc/datadog/synthetics-check-runner.json
```

- Run docker-compose up -d
- Use datadog synthetics API grpc with following traefik configs (not working),

```
 server name : traefik
 port: 80
 service: grpc.health.v1.Health
 advance option -> ignore server certificate error : true
```

- Use datadog synthetics API grpc with following health server configs (works),

```
 server name : health-server
 port: 3333
 service: grpc.health.v1.Health
 advance option -> ignore server certificate error : true
```

## conclusion

- Synthetic private location accessing server directly works, but not via the traefik proxy. However both of these setups (server and traefik) works with grpcCurl libraries.
