-- Deploy ftlc:extensions to pg

BEGIN;

CREATE EXTENSION citext;

CREATE EXTENSION "uuid-ossp";

CREATE EXTENSION pgcrypto;

COMMIT;
