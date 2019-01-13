-- Deploy ftlc:promo_code to pg
-- requires: date_group
-- requires: users

BEGIN;

CREATE TABLE ftlc.promo_code(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL,
    for_catagory BOOLEAN,
    for_event BOOLEAN,
    for_user BOOLEAN,
    percent BOOLEAN,
    catagory UUID REFERENCES ftlc.activity_catagories(id),
    event UUID REFERENCES ftlc.events(id),
    user UUID REFERENCES ftlc.users(id),
    effect INTEGER,
    uses INTEGER,
    valid_start TIMESTAMP DEFAULT NOW(),
    valid_end TIMESTAMP
);

COMMIT;