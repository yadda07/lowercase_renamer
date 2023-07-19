CREATE OR REPLACE FUNCTION lowername_table(schema_names text[])
  RETURNS VOID AS
$$
DECLARE
  current_schema_name text;
  current_table_name text;
BEGIN
  FOREACH current_schema_name IN ARRAY schema_names LOOP
    FOR current_table_name IN (SELECT table_name FROM information_schema.tables WHERE table_schema = current_schema_name) LOOP
      IF current_table_name <> lower(current_table_name) THEN
        EXECUTE 'ALTER TABLE "' || current_schema_name || '"."' || current_table_name || '" RENAME TO "' || lower(current_table_name) || '"';
      END IF;
    END LOOP;
  END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECt minirenom_table(array['dsp_rochelle'])
