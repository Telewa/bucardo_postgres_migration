# bucardo postgres migration

This is a tool that can used for replication of postgres databases

### REF:
- https://bucardo.org/Bucardo/Installation.html 

### Update details in the following files:
- docker-compose.yml
- bucardorc
- pg_hba.conf
- commands.sql

### NOTE: 
- The details in bucardorc must match those in commands.sql
- implement a better system than using "trust" in pg_hba.conf
