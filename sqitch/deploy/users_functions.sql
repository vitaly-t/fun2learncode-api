-- Deploy ftlc:users_functions to pg
-- requires: users

BEGIN;

CREATE FUNCTION ftlc.register_user(
    first_name citext,
    last_name citext,
    email citext,
    password text) RETURNS ftlc.users AS $$
    DECLARE
        person ftlc.users;
    BEGIN
        INSERT INTO ftlc.users (first_name, last_name, role) VALUES ($1, $2, 'ftlc_user') returning * into person;
        INSERT INTO ftlc_private.users(user_id, email, password_hash) VALUES ((person).id, $3, crypt($4, gen_salt('bf')));
        RETURN person;
    END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

CREATE FUNCTION ftlc.register_student(
    first_name citext,
    last_name citext,
    email citext,
    password text) RETURNS ftlc.users AS $$
    DECLARE
        person ftlc.users;
    BEGIN
        INSERT INTO ftlc.users (first_name, last_name, role) VALUES ($1, $2, 'ftlc_student') returning * into person;
        INSERT INTO ftlc_private.users(user_id, email, password_hash) VALUES ((person).id, $3, crypt($4, gen_salt('bf')));
        RETURN person;
    END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

CREATE FUNCTION ftlc.register_instructor(
    first_name citext,
    last_name citext,
    email citext,
    password text) RETURNS ftlc.users AS $$
    DECLARE
        person ftlc.users;
    BEGIN
        INSERT INTO ftlc.users (first_name, last_name, role) VALUES ($1, $2, 'ftlc_instructor') returning * into person;
        INSERT INTO ftlc_private.users(user_id, email, password_hash) VALUES ((person).id, $3, crypt($4, gen_salt('bf')));
        RETURN person;
    END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

CREATE FUNCTION ftlc.authenticate(CITEXT, password text) RETURNS ftlc.jwt_token AS $$
  DECLARE
    person ftlc_private.users;
    public_person ftlc.users;
    BEGIN
        select a.* into person
        from ftlc_private.users as a
        where a.email = $1;
        select a.* into public_person
        from ftlc.users as a
        where a.id = person.user_id;
        IF (person).password_hash = crypt(password, (person).password_hash) then
            RETURN((public_person).role, (SELECT (extract(epoch from (now()+'14 day'::interval)))::integer), (public_person).id)::ftlc.jwt_token;
        ELSE
            RETURN null;
        END IF;
    END;
$$ LANGUAGE PLPGSQL STRICT SECURITY DEFINER;

CREATE FUNCTION ftlc.get_user_data() RETURNS ftlc.users AS $$
    DECLARE
        person ftlc.users;
    BEGIN
        select a.* into person from ftlc.users as a where a.id = ftlc.get_id();
        RETURN ROW(person.id, person.first_name, person.last_name, person.role)::ftlc.users;
    END;
$$ LANGUAGE PLPGSQL STABLE;

CREATE FUNCTION ftlc.get_id() RETURNS UUID AS $$
    SELECT uuid(current_setting('jwt.claims.id', true));
$$ LANGUAGE SQL;
COMMIT;