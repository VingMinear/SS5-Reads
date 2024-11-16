from flask import jsonify
from database.db import PgConfig
from psycopg2 import DatabaseError

class HelperResponse:
    @staticmethod
    def success(data=None, message="Response Success"):
        """Helper function to return a success response."""
        response = {
            'code': 200,
            'message': message
        }
        if data is not None:
            response['data'] = data
        return jsonify(response), 200  # Added status code 200 for clarity

    @staticmethod
    def error(message='An error occurred', stack=None, code=500):
        """Helper function to return an error response."""
        response = {
            'message': message,
            'code': code
        }
        if stack:
            response['stack'] = stack
        return jsonify(response), code  # Using the passed error code


def query(sql, params=None):
    """Execute a SELECT query with optional parameters."""
    with PgConfig.get_cursor() as cursor:  # Ensures the cursor is properly closed
        try:

            if params is not None:
                cursor.execute(sql, params or ())
            else:
                cursor.execute(sql)
            result = cursor.fetchall()
            PgConfig.pg_commit()

            return result
        except DatabaseError as e:
            # Handle database-specific errors
            return f"Database error: {str(e)}"


def query_condition(sql, params=None):
    """Execute an INSERT, UPDATE, DELETE query with optional parameters."""
    with PgConfig.get_cursor() as cursor:  # Ensures the cursor is properly closed
        try:
            print(sql)
            if params is not None:
                cursor.execute(sql, params or ())
            else:
                cursor.execute(sql)
            PgConfig.pg_commit()  # Commit only for modifying queries

        except DatabaseError as e:
            # Handle database-specific errors
            return f"Database error: {str(e)}"
