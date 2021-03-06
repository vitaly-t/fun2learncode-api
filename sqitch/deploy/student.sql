-- Deploy ftlc:students to pg
-- requires: users_functions

BEGIN;

CREATE TABLE ftlc.student(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent UUID REFERENCES ftlc.users(id) DEFAULT ftlc.get_id() NOT NULL,
    first_name CITEXT NOT NULL CHECK(first_name != ''),
    last_name CITEXT NOT NULL CHECK(last_name != ''),
    date_of_birth TIMESTAMPTZ NOT NULL
);

COMMIT;
