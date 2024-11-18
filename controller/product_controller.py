from sqlite3 import DatabaseError

from flask import jsonify, request

from database.db import PgConfig
from util.utils import HelperResponse, query, query_condition


class ProductController:
    @staticmethod
    def get_product_detail(request):
        data = request.json
        customer_id = data.get('customer_id')
        product_id = data.get('product_id')

        try:
            if customer_id:

                sql = f"""
                       SELECT
                           pro.product_id,
                           pro.product_name,
                           pro.qty,
                           pro.desc,
                           pro.image,
                           pro.price_in,
                           pro.price_out,
                           MAX(fav.id) AS favId, -- Use MAX to get a single favId if it exists
                           pro.sold AS sold,
                           cat.id AS category_id,
                           cat.category_name,
                           MAX(CASE WHEN fav.customer_id = {customer_id} THEN 1 ELSE 0 END) AS isFav
                       FROM tbl_product pro
                       JOIN tbl_category cat ON cat.id = pro.category_id
                       LEFT JOIN tbl_favorites fav ON fav.product_id = pro.product_id
                           AND fav.customer_id = {customer_id}
                       WHERE pro.product_id = {product_id} AND pro.qty > 0
                       GROUP BY pro.product_id, cat.id, pro.product_name, pro.qty, pro.desc, pro.image, pro.price_in, pro.price_out, pro.sold, cat.category_name;
                   """
                print(sql)
                result = query(sql)
            else:
                sql = f"""
                       SELECT
                           pro.product_id,
                           pro.product_name,
                           pro.qty,
                           pro.desc,
                           pro.image,
                           pro.price_in,
                           pro.price_out,
                           pro.sold AS sold,
                           cat.id AS category_id,
                           cat.category_name
                       FROM tbl_product pro
                       JOIN tbl_category cat ON cat.id = pro.category_id
                       WHERE pro.product_id = {product_id};
                   """
                result = query(sql)

            return HelperResponse.success(result[0])

        except Exception as e:
            return HelperResponse.error("Failed to fetch product details", str(e))

    @staticmethod
    def get_product(request):
        customer_id = request.args.get('customer_id')
        search = request.args.get('search', '')

        try:
            if customer_id:
                sql = f"""
                    SELECT
                        pro.product_id,
                        pro.product_name,
                        pro.qty,
                        pro.desc,
                        pro.image,
                        pro.price_in,
                        pro.price_out,
                        pro.sold AS sold,
                        cat.id AS category_id,
                        cat.category_name,
                        COALESCE(MAX(fav.id), 0) AS favId, -- Ensure no NULL values
                        COALESCE(MAX(CASE WHEN fav.customer_id = {customer_id} THEN 1 ELSE 0 END), 0) AS isFav
                    FROM tbl_product pro
                    JOIN tbl_category cat ON cat.id = pro.category_id
                    LEFT JOIN tbl_favorites fav ON fav.product_id = pro.product_id
                    WHERE pro.qty > 0 AND pro.product_name LIKE '%{search}%'
                    GROUP BY pro.product_id, pro.product_name, pro.qty, pro.desc, pro.image, pro.price_in, 
                             pro.price_out, pro.sold, cat.id, cat.category_name;
                """
                result = query(sql)
            else:
                sql = f"""
                    SELECT
                        pro.product_id,
                        pro.product_name,
                        pro.qty,
                        pro.desc,
                        pro.image,
                        pro.price_in,
                        pro.price_out,
                        pro.sold AS sold,
                        cat.id AS category_id,
                        cat.category_name
                    FROM tbl_product pro
                    JOIN tbl_category cat ON cat.id = pro.category_id
                    WHERE pro.product_name LIKE '%{search}%';
                """
                result = query(sql)

            return HelperResponse.success(result)

        except Exception as e:
            return HelperResponse.error("Failed to fetch products", str(e))

    @staticmethod
    def get_category(req):
        try:
            sql = "SELECT * FROM tbl_category;"
            result = query(sql)
            return HelperResponse.success(result)
        except Exception as e:
            return HelperResponse.error("Failed to fetch categories", str(e))

    @staticmethod
    def add_category(request):
        data = request.json
        category_name = data.get("category_name")
        image = data.get("image")
        try:
            sql = f"INSERT INTO tbl_category (category_name, image) VALUES ('{category_name}', '{image}');"
            query_condition(sql)
            return HelperResponse.success("Category added successfully")
        except Exception as e:
            return HelperResponse.error("Failed to add category", str(e))

    @staticmethod
    def update_category(request):
        data = request.json
        category_id = data.get("id")
        category_name = data.get("category_name")
        image = data.get("image")
        try:
            sql = f"UPDATE tbl_category SET category_name = '{category_name}', image = '{image}' WHERE id = {category_id};"
            query_condition(sql)
            return HelperResponse.success("Category updated successfully")
        except Exception as e:
            return HelperResponse.error("Failed to update category", str(e))

    @staticmethod
    def delete_category(request):
        category_id = request.json.get("id")
        try:
            sql = f"DELETE FROM tbl_category WHERE id = {category_id};"
            query_condition(sql)
            return HelperResponse.success("Category deleted successfully")
        except Exception as e:
            return HelperResponse.error("Failed to delete category", str(e))

    @staticmethod
    def get_product_by_category(request):
        data = request.json
        category_id = data.get("category_id")
        customer_id = data.get("customer_id")
        search = data.get("search", "")

        try:
            # Ensure category_id is provided
            if not category_id:
                return HelperResponse.error("Category ID is required", "Missing parameter: category_id")

            # Convert to integers and handle missing customer_id
            category_id = int(category_id)
            customer_id_clause = ""

            if customer_id:
                customer_id = int(customer_id)
                customer_id_clause = f"""
                    , fav.id AS favId
                    , CASE WHEN fav.customer_id = {customer_id} THEN 1 ELSE 0 END AS isFav
                """
                join_clause = f"""
                    LEFT JOIN tbl_favorites fav ON fav.product_id = pro.product_id AND fav.customer_id = {customer_id}
                """
            else:
                customer_id_clause = """
                    , NULL AS favId
                    , 0 AS isFav
                """
                join_clause = "LEFT JOIN tbl_favorites fav ON fav.product_id = pro.product_id"

            # SQL query with dynamic customer-related fields
            sql = f"""
                SELECT
                    pro.product_id,
                    pro.product_name,
                    pro.qty,
                    pro.desc,
                    pro.image,
                    pro.price_in,
                    pro.price_out,
                    pro.sold AS sold,
                    cat.id AS category_id,
                    cat.category_name
                    {customer_id_clause}
                FROM tbl_product pro
                JOIN tbl_category cat ON cat.id = pro.category_id
                {join_clause}
                WHERE cat.id = {category_id} AND pro.qty > 0 AND pro.product_name LIKE '%{search}%';
            """

            result = query(sql)
            return HelperResponse.success(result)

        except ValueError as e:
            return HelperResponse.error("Invalid parameter type", "category_id and customer_id must be integers")
        except Exception as e:
            return HelperResponse.error("Failed to fetch products by category", str(e))

    @staticmethod
    def add_product(request):
        data = request.json
        product_name = data.get("product_name")
        qty = data.get("qty")
        category_id = data.get("category_id")
        image = data.get("image", "")
        price_in = data.get("price_in")
        price_out = data.get("price_out")
        try:
            sql = f"""
                INSERT INTO tbl_product (product_name, qty, category_id, image, price_in, price_out)
                VALUES ('{product_name}', {qty}, {category_id}, '{image}', {price_in}, {price_out});
            """
            query_condition(sql)
            return HelperResponse.success("Product added successfully")
        except Exception as e:
            return HelperResponse.error("Failed to add product", str(e))

    @staticmethod
    def update_product(request):
        data = request.json
        product_id = data.get("product_id")
        product_name = data.get("product_name")
        qty = data.get("qty")
        category_id = data.get("category_id")
        image = data.get("image", "")
        price_in = data.get("price_in")
        price_out = data.get("price_out")

        try:
            sql = f"""
                UPDATE tbl_product
                SET product_name = '{product_name}', qty = {qty}, category_id = {category_id},
                    image = '{image}', price_in = {price_in}, price_out = {price_out}
                WHERE product_id = {product_id};
            """
            query_condition(sql)
            return HelperResponse.success("Product updated successfully")
        except Exception as e:
            return HelperResponse.error("Failed to update product", str(e))

    @staticmethod
    def delete_product(request):
        product_id = request.json.get("product_id")
        try:
            sql = f"DELETE FROM tbl_product WHERE product_id = {product_id};"
            query_condition(sql)
            return HelperResponse.success("Product deleted successfully")
        except Exception as e:
            return HelperResponse.error("Failed to delete product", str(e))
