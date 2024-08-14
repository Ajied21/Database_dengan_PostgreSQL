import psycopg2
from psycopg2 import sql

host = 'localhost'
dbname = 'project-dibimbing'
user = 'ajied'
password = 'admin123'


try:
    connection = psycopg2.connect(
        host=host,
        dbname=dbname,
        user=user,
        password=password
    )


    cursor = connection.cursor()


    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print(f"PostgreSQL database version: {db_version}\n")
    print(f"connecting to PostgreSQL database success")


    cursor.close()
    connection.close()

except Exception as error:
    print(f"Error connecting to PostgreSQL database: {error}")
