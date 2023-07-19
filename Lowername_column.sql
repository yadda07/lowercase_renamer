CREATE OR REPLACE FUNCTION muliminirenom(schema_names text[])
  RETURNS VOID AS
$$
DECLARE
  r record;
  col_name text;
  schema_name text;
BEGIN
  -- Parcourir chaque schéma dans la liste
  FOREACH schema_name IN ARRAY schema_names LOOP
    -- Récupérer le nom des tables dans le schéma spécifié
    FOR r IN (SELECT table_name FROM information_schema.tables WHERE table_schema = schema_name) LOOP
      -- Récupérer les noms des colonnes de la table actuelle
      FOR col_name IN (SELECT column_name FROM information_schema.columns WHERE table_schema = schema_name AND table_name = r.table_name) LOOP
        -- Vérifier si le nom de la colonne est déjà en minuscules
        IF col_name <> lower(col_name) THEN
          -- Récupérer le nom de la colonne avec la casse correcte
          EXECUTE format(
            'SELECT column_name FROM information_schema.columns WHERE table_schema = %L AND table_name = %L AND column_name = %L',
            schema_name, r.table_name, col_name) INTO col_name;
          -- Exécuter la requête ALTER TABLE pour renommer la colonne
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