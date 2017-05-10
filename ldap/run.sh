#!/bin/bash


set -ueo pipefail

LDAP_DOMAIN_DC="dc=$(echo $LDAP_DOMAIN | sed 's/\./,dc=/')"
LDAP_DOMAIN_TOP=$(echo $LDAP_DOMAIN | sed 's/\..*//')
LDAP_PASSWORD_ENC=$(slappasswd -h {SSHA} -s $LDAP_PASSWORD)

# Delete data
TMPDIR=$(mktemp -d)
if [ -f /var/lib/ldap/DB_CONFIG ]
then
  rm -f $TMPDIR/DB_CONFIG
  cp -v /var/lib/ldap/DB_CONFIG ./DB_CONFIG
fi
rm -rf /etc/ldap/slapd.d/*
rm -rf /var/lib/ldap/*
if [ -f $TMPDIR/DB_CONFIG ]
then
  cp -v $TMPDIR/DB_CONFIG /var/lib/ldap/DB_CONFIG
  rm -rf $TMPDIR
fi

# Reconfigure
sed -e 's/{DOMAIN}/'"$LDAP_DOMAIN_DC"'/' /etc/ldap/init/slapd.conf.ldif | sed -e 's!{PASSWORD_ENC}!'"$LDAP_PASSWORD_ENC"'!' | slapadd -F /etc/ldap/slapd.d -b "cn=config"
# Load memberof and ref-int overlays and configure them.
cat /etc/ldap/init/memberof.ldif | slapadd -F /etc/ldap/slapd.d -b "cn=config"

# Add base domain.
slapadd -F /etc/ldap/slapd.d <<EOM
dn: $LDAP_DOMAIN_DC
objectClass: top
objectClass: domain
dc: $LDAP_DOMAIN_TOP
EOM

chown -R openldap:openldap /etc/ldap/slapd.d
chown -R openldap:openldap /var/lib/ldap

/etc/init.d/slapd start

# Import data.
sed -e 's/{DOMAIN}/'"$LDAP_DOMAIN_DC"'/' /etc/ldap/init/db.ldif |
  ldapadd -x -D "cn=admin,$LDAP_DOMAIN_DC" -w $LDAP_PASSWORD -h localhost -p 389

# Seed the database with users and groups
sed -e 's/{DOMAIN}/'"$LDAP_DOMAIN_DC"'/' /etc/ldap/init/groups.ldif | ldapadd -x -D "cn=admin,$LDAP_DOMAIN_DC" -w $LDAP_PASSWORD -h localhost -p 389
sed -e 's/{DOMAIN}/'"$LDAP_DOMAIN_DC"'/' /etc/ldap/init/users.ldif | ldapadd -x -D "cn=admin,$LDAP_DOMAIN_DC" -w $LDAP_PASSWORD -h localhost -p 389

# Kill slapd so we can start it in the foreground
kill $(pidof slapd)

# wait for slapd to receive the above kill signal and exit
while [[ "$(pidof slapd)" != "" ]]; do true; done

exec /usr/sbin/slapd -F /etc/ldap/slapd.d -h "ldapi:/// ldap:/// ldaps:///" -d stats
