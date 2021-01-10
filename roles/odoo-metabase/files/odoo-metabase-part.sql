
CREATE SEQUENCE IF NOT EXISTS odoo_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS odoo_version(
    id integer PRIMARY KEY DEFAULT nextval('odoo_version_id_seq'),
    version varchar NOT NULL,
    port integer,
    longpolling_port integer
);
CREATE TABLE IF NOT EXISTS odoo_database (
    id integer PRIMARY KEY DEFAULT nextval('service_instance_id_seq'), -- share the same sequence as odoo_database implements a service instance useing trigger
    name varchar NOT NULL UNIQUE,
    create_date timestamp without time zone DEFAULT (NOW() AT TIME ZONE 'utc'),
    description varchar NULL,
    use_backup boolean DEFAULT TRUE,
    version_id integer NOT NULL REFERENCES odoo_version(id) ON DELETE RESTRICT
);

ALTER SEQUENCE odoo_version_id_seq OWNED BY odoo_version.id;


CREATE OR REPLACE FUNCTION odoo_database_insert_trigger_fnc() RETURNS trigger AS
$$
    BEGIN
        INSERT INTO "service_instance" ("id", "name", "description", "use_backup", "service_type")
        VALUES(NEW."id", NEW."name", NEW."description", NEW."use_backup", 'odoo');
        RETURN NEW;
    END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS odoo_database_insert_trigger ON "odoo_database";
CREATE TRIGGER odoo_database_insert_trigger
AFTER INSERT ON "odoo_database"
FOR EACH ROW
EXECUTE PROCEDURE odoo_database_insert_trigger_fnc();


CREATE OR REPLACE FUNCTION odoo_database_update_trigger_fnc() RETURNS trigger AS
$$
    BEGIN
        UPDATE "service_instance" SET name = NEW."name", description = NEW."description", use_backup = NEW."use_backup" WHERE id = NEW."id";
        RETURN NEW;
    END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS odoo_database_update_trigger ON "odoo_database";
CREATE TRIGGER odoo_database_update_trigger
AFTER UPDATE ON "odoo_database"
FOR EACH ROW
EXECUTE PROCEDURE odoo_database_update_trigger_fnc();



CREATE OR REPLACE FUNCTION odoo_database_delete_trigger_fnc() RETURNS trigger AS
$$
    BEGIN
        DELETE FROM "service_instance" WHERE id = OLD."id";
        RETURN OLD;
    END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS odoo_database_delete_trigger ON "odoo_database";
CREATE TRIGGER odoo_database_delete_trigger
AFTER DELETE ON "odoo_database"
FOR EACH ROW
EXECUTE PROCEDURE odoo_database_delete_trigger_fnc();
