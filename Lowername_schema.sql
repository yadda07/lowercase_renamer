CREATE OR REPLACE FUNCTION lowername_schema()
  RETURNS VOID AS
$$
DECLARE
  current_schema_name text;
BEGIN
  FOR current_schema_name IN (SELECT schema_name FROM information_schema.schemata) LOOP
    IF current_schema_name <> lower(current_schema_name) THEN
      EXECUTE 'ALTER SCHEMA "' || current_schema_name || '" RENAME TO "' || lower(current_schema_name) || '"';
    END IF;
  END LOOP;
END;
$$
LANGUAGE plpgsql;


SELECT minirenom_schema()