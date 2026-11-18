CREATE OR REPLACE FUNCTION lowername_schema()
  RETURNS void
  LANGUAGE plpgsql
AS $$
DECLARE
  current_schema_name text;
BEGIN
  FOR current_schema_name IN
    SELECT schema_name
    FROM information_schema.schemata
    WHERE schema_name NOT LIKE 'pg_%'
      AND schema_name <> 'information_schema'
  LOOP
    IF current_schema_name <> lower(current_schema_name) THEN
      EXECUTE format('ALTER SCHEMA %I RENAME TO %I', current_schema_name, lower(current_schema_name));
    END IF;
  END LOOP;
END;
$$;

-- Example:
-- SELECT lowername_schema();
