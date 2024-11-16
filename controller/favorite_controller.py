from flask import jsonify, request
from database.db import PgConfig
from psycopg2 import DatabaseError


class FavoriteController:

    @staticmethod
    def get_favorite():
        data = request.json
        customer_id = data.get('customer_id')

        # Validate customer_id
        if not customer_id:
            return jsonify({'message': 'Customer ID is required', 'code': 400}), 400

        try:
            # Convert customer_id to integer to prevent SQL injection risks
            customer_id = int(customer_id)

            query = """
                SELECT
                    pro.product_id,
                    pro.product_name,
                    pro.qty,
                    pro.desc,
                    pro.image,
                    pro.price_in,
                    pro.price_out,
                    cat.id AS category_id,
                    cat.category_name,
                    1 AS isFav
                FROM tbl_favorites fav
                JOIN tbl_product pro ON pro.product_id = fav.product_id
                JOIN tbl_category cat ON cat.id = pro.category_id
                WHERE fav.customer_id = %s AND fav.favorite = TRUE;
            """

            # Execute the query and fetch results
            with PgConfig.get_cursor() as cursor:
                cursor.execute(query, (customer_id,))
                favorites = cursor.fetchall()

            return jsonify({'message': 'Favorites retrieved successfully', 'data': favorites, 'code': 200}), 200

        except ValueError:
            return jsonify({'message': 'Invalid customer ID format', 'code': 400}), 400
        except DatabaseError as e:
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def add_favorite():
        data = request.json
        customer_id = data.get('customer_id')
        product_id = data.get('product_id')
        favorite = bool(data.get('favorite', True))  # Convert to boolean, default to True

        if not customer_id or not product_id:
            return jsonify({'message': 'Customer ID and Product ID are required', 'code': 400}), 400

        try:
            cursor = PgConfig.get_cursor()
            query = """
                INSERT INTO tbl_favorites (customer_id, product_id, favorite)
                VALUES (%s, %s, %s);
            """
            cursor.execute(query, (customer_id, product_id, favorite))
            PgConfig.pg_commit()
            cursor.close()

            return jsonify({'message': 'Favorite added successfully', 'code': 200}), 200
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def update_favorite():
        data = request.json
        customer_id = data.get('customer_id')
        product_id = data.get('product_id')

        if not customer_id or not product_id:
            return jsonify({'message': 'Customer ID and Product ID are required', 'code': 400}), 400

        try:
            cursor = PgConfig.get_cursor()
            query = """
                DELETE FROM tbl_favorites
                WHERE customer_id = %s AND product_id = %s;
            """
            cursor.execute(query, (customer_id, product_id))
            PgConfig.pg_commit()
            cursor.close()

            return jsonify({'message': 'Favorite updated successfully', 'code': 200}), 200
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def delete_favorite():
        data = request.json
        fav_id = data.get('id')

        if not fav_id:
            return jsonify({'message': 'Favorite ID is required', 'code': 400}), 400

        try:
            cursor = PgConfig.get_cursor()
            query = "DELETE FROM tbl_favorites WHERE id = %s;"
            cursor.execute(query, (fav_id,))
            PgConfig.pg_commit()
            cursor.close()

            return jsonify({'message': 'Favorite deleted successfully', 'code': 200}), 200
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500
