CREATE OR REPLACE FUNCTION lowername_column(schema_names text[])
  RETURNS void
  LANGUAGE plpgsql
AS $$
DECLARE
  current_schema_name text;
  current_table_name text;
  current_col_name text;
BEGIN
  FOREACH current_schema_name IN ARRAY schema_names LOOP
    FOR current_table_name IN
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = current_schema_name
        AND table_type = 'BASE TABLE'
    LOOP
      FOR current_col_name IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = current_schema_name
          AND table_name = current_table_name
      LOOP
        IF current_col_name <> lower(current_col_name) THEN
          EXECUTE format(
            'ALTER TABLE %I.%I RENAME COLUMN %I TO %I',
            current_schema_name,
            current_table_name,
            current_col_name,
            lower(current_col_name)
          );
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END;
$$;

-- Example:
-- SELECT lowername_column(ARRAY['public', 'gis']);
