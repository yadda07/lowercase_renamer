CREATE OR REPLACE FUNCTION lowername_table(schema_names text[])
  RETURNS void
  LANGUAGE plpgsql
AS $$
DECLARE
  current_schema_name text;
  current_table_name text;
BEGIN
  FOREACH current_schema_name IN ARRAY schema_names LOOP
    FOR current_table_name IN
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = current_schema_name
        AND table_type = 'BASE TABLE'
    LOOP
      IF current_table_name <> lower(current_table_name) THEN
        EXECUTE format(
          'ALTER TABLE %I.%I RENAME TO %I',
          current_schema_name,
          current_table_name,
          lower(current_table_name)
        );
      END IF;
    END LOOP;
  END LOOP;
END;
$$;

-- Example:
-- SELECT lowername_table(ARRAY['public', 'gis']);
