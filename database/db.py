import psycopg2
from psycopg2.extras import RealDictCursor

# Single connection setup
con = psycopg2.connect(
    dbname="book_store",
    user="postgres",
    password="root",
    host="localhost",
    port="5432",
    cursor_factory=RealDictCursor   
)

class PgConfig:
    @staticmethod
    def get_cursor():
        """Get a database cursor with DictCursor format."""
        global con  # Declare global variable at the start
        try:
            return con.cursor(cursor_factory=RealDictCursor)
        except psycopg2.InterfaceError:
            # Reconnect if the connection is closed or lost
            con = psycopg2.connect(
                dbname="book_store",  # Use correct database name
                user="postgres",
                password="root",
                host="localhost",
                port="5432",
                cursor_factory=RealDictCursor
            )
            return con.cursor(cursor_factory=RealDictCursor)

    @staticmethod
    def pg_commit():
        """Commit the current transaction."""
        global con  # Declare global variable
        con.commit()

    @staticmethod
    def pg_rollback():
        """Rollback the current transaction."""
        global con  # Declare global variable
        print("---------------rolling back------------")
        con.rollback()

    @staticmethod
    def close():
        """Close the database connection."""
        global con  # Declare global variable
        if con:
            con.close()
