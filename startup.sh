#!/usr/bin/env bash

echo "starting postgres"
service postgresql start

echo "create bucardo db"
su - postgres -c 'psql < /commands.sql'

echo "install bucardo database"
bucardo --bucardorc /tmp/bucardorc install --batch
bucardo show all # should show a config

echo "fetching tables to migrate"
TABLES=`export PGPASSWORD=$SRC_PASS;psql -U $SRC_USER -h $SRC_HOST -d $SRC_DB -t -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' GROUP BY table_name;"`

echo "tables to migrate are: " ${TABLES}

echo "Create the source and target database objects"
bucardo add db benchsrc host=$SRC_HOST dbname=$SRC_DB user=$SRC_USER pass=$SRC_PASS
bucardo add db benchdst host=$DST_HOST dbname=$DST_DB user=$DST_USER pass=$DST_PASS

### postgres will assume a schema of "public", if you have a different schema
### each table needs to be prefixed with that
echo "Tell Bucardo about the tables that we want to replicate, and which database to use as the source:"
bucardo add tables $TABLES db=benchsrc
#
echo "Add the tables to a 'herd' (like a replication group I guess?):"
bucardo add herd benchherd $TABLES
#
#echo "Create the sync object."
bucardo add sync benchsync relgroup=benchherd dbs=benchsrc:source,benchdst:target onetimecopy=2
#
### It’s useful to set logging more verbose than default:
echo "set logging more verbose"
bucardo set log_showlevel=1
bucardo set log_level=verbose #or "debug"
#
#
echo "starting replication"
### And finally start the process:
bucardo start
### or - bucardo reload
while sleep 5; do
	echo "syncing..."
	bucardo status benchsync
done

echo "Exiting."
echo "stopping postgres"
service postgresql stop
