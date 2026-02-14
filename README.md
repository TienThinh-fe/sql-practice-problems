# SQL Practice Problems

Solutions for the book **"SQL Practice Problems"** by Sylvia Moestl Vasilik.

## Setup

Requires PostgreSQL. Load the database:

```sql
psql -U postgres -f northwind2016-postgres.sql
```

Or use Docker:

```bash
docker run -d --name postgres-northwind -e POSTGRES_PASSWORD=postgres -p 54321:5432 postgres:16
docker exec -i postgres-northwind psql -U postgres < northwind2016-postgres.sql
```

## Files

- `Script-1.sql` - My solutions
- `northwind2016-postgres.sql` - Northwind2016 database (PostgreSQL)
