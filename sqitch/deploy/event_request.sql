-- Deploy ftlc:event_request to pg
-- requires: event
-- requires: users

BEGIN;

CREATE TABLE ftlc.event_request(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES ftlc.users(id) DEFAULT ftlc.get_id() NOT NULL,
    event UUID REFERENCES ftlc.event(id),
    created_on TIMESTAMPTZ DEFAULT NOW(),
    information CITEXT NOT NULL, -- location, cost, capacity, general event description
    access_token TEXT UNIQUE,
    status ftlc.request_type DEFAULT 'pending'
);

COMMIT;
