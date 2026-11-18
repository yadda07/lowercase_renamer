# lowercase_renamer

PL/pgSQL utility functions to normalize PostgreSQL schema, table, and column identifiers to lowercase for GIS tools, ETL pipelines, and APIs that reject mixed-case identifiers.

## Functions

| Script | Function | Purpose |
|---|---|---|
| `Lowername_schema.sql` | `lowername_schema()` | Renames user schemas containing uppercase characters to lowercase |
| `Lowername_table.sql` | `lowername_table(text[])` | Renames base tables to lowercase across the target schemas |
| `Lowername_column.sql` | `lowername_column(text[])` | Renames table columns to lowercase across the target schemas |

## Usage

```sql
SELECT lowername_schema();
SELECT lowername_table(ARRAY['public', 'gis']);
SELECT lowername_column(ARRAY['public', 'gis']);
```
