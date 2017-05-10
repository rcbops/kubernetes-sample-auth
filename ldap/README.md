# LDAP

This is a basic LDAP server that can be run in a Docker container. It is pre-populated with several users with simple passwords that can easily be used for testing various authentication/authorization scenarios.

## Building the image

The LDIF files in `ldif/` are used to populate the LDAP database. If you want to add a user, group, or any other object to the database in a persistent way, you should add it to one of these files, then build and restart your container.

```bash
docker build -t ldap .
```

## Running the image

The only important thing is to specify the `LDAP_PASSWORD` environment variable to something you know. Currently the only user that can search and modify the entire database is `cn=admin,dc=example,dc=com`, so you'll need to use that DN and the value of `LDAP_PASSWORD` to bind to the LDAP server. Besides that, run the container however you please:

```bash
docker run --rm -p 389:389 -e LDAP_PASSWORD=password ldap
```

## To-dos

* StartTLS or LDAPS support
* Service accounts that can search the database
* `memberOf` returned as a user property
