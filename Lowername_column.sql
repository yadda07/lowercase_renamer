CREATE OR REPLACE FUNCTION muliminirenom(schema_names text[])
  RETURNS VOID AS
$$
DECLARE
  r record;
  col_name text;
  schema_name text;
BEGIN
  FOREACH schema_name IN ARRAY schema_names LOOP
    FOR r IN (SELECT table_name FROM information_schema.tables WHERE table_schema = schema_name) LOOP
      FOR col_name IN (SELECT column_name FROM information_schema.columns WHERE table_schema = schema_name AND table_name = r.table_name) LOOP
        IF col_name <> lower(col_name) THEN
          EXECUTE format(
            'SELECT column_name FROM information_schema.columns WHERE table_schema = %L AND table_name = %L AND column_name = %L',
            schema_name, r.table_name, col_name) INTO col_name;
          EXECUTE format(
            'ALTER TABLE %I.%I RENAME COLUMN %I TO %I',
            schema_name, r.table_name, col_name, lower(col_name));
        END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT muliminirenom(array['dsp_corsicathd','dsp_rochelle'])
