
CREATE SEQUENCE IF NOT EXISTS service_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE SEQUENCE IF NOT EXISTS domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS service_instance (
    id integer PRIMARY KEY DEFAULT nextval('service_instance_id_seq'),
    name varchar NOT NULL UNIQUE,
    create_date timestamp without time zone DEFAULT (NOW() AT TIME ZONE 'utc'),
    description varchar NULL,
    service_type varchar NOT NULL,
    use_backup boolean DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS domain (
    id integer PRIMARY KEY DEFAULT nextval('domain_id_seq'),
    name varchar NOT NULL UNIQUE,
    use_ssl boolean DEFAULT FALSE,
    service_id integer NOT NULL REFERENCES service_instance(id) ON DELETE RESTRICT
);

ALTER SEQUENCE service_instance_id_seq OWNED BY service_instance.id;
ALTER SEQUENCE domain_id_seq OWNED BY domain.id;


