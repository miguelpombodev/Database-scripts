sleep 5s

/opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P "$MSSQL_SA_PASSWORD" -C -i Foodie_API_Script.sql