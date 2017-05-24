# Keystone

This is a basic Keystone instance that can be run in a Docker container. It is pre-populated with several users with simple passwords that can easily be used for testing various authentication/authorization scenarios.

## Running the service

```bash
docker stack up --compose-file ./docker-compose.yml keystone
```

## Modify the openstack config

The `keystone-public` service of the docker stack is configured with all the environment variables needed to run the `openstack` CLI as an admin:

```bash
docker exec -it $(docker ps -q -f label=com.docker.swarm.service.name=keystone_keystone-public) bash
$ openstack user list
```

As you make changes to Keystone, the changes will be persisted in the MySQL database. However, in order to persist those changes for the next time the MySQL container starts, you'll need to export the database to a file at `./keystone.sql`. This file is mounted as a volume and executed when the MySQL container starts in order to populate the database. Use the following shell script if you need to export the database to a local file:

```bash
./export-database.sh $(docker ps -q -f label=com.docker.swarm.service.name=keystone_mysql)
```
