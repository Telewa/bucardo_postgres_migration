create database mydb;
CREATE ROLE dbuser LOGIN SUPERUSER PASSWORD 'dbpass';
grant all privileges on database mydb to dbuser;