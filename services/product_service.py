from database.db import PgConfig

class ProductService:
    @staticmethod
    def get_all_products():
        cursor = PgConfig.get_cursor()
        cursor.execute("SELECT * FROM products")
        products = cursor.fetchall()
        cursor.close()
        return products

    @staticmethod
    def get_product_by_id(product_id):
        cursor = PgConfig.get_cursor()
        cursor.execute("SELECT * FROM products WHERE id = %s", (product_id,))
        product = cursor.fetchone()
        cursor.close()
        return product

    @staticmethod
    def add_product(data):
        cursor = PgConfig.get_cursor()
        cursor.execute(
            "INSERT INTO products (name, description, price, category_id, image) VALUES (%s, %s, %s, %s, %s) RETURNING id",
            (data['name'], data.get('description'), data['price'], data.get('category_id'), data.get('image'))
        )
        product_id = cursor.fetchone()['id']
        PgConfig.pg_commit()
        cursor.close()
        return ProductService.get_product_by_id(product_id)

    @staticmethod
    def update_product(product_id, data):
        cursor = PgConfig.get_cursor()
        cursor.execute(
            "UPDATE products SET name = %s, description = %s, price = %s, category_id = %s, image = %s WHERE id = %s",
            (data['name'], data.get('description'), data['price'], data.get('category_id'), data.get('image'), product_id)
        )
        PgConfig.pg_commit()
        cursor.close()
        return ProductService.get_product_by_id(product_id)

    @staticmethod
    def delete_product(product_id):
        cursor = PgConfig.get_cursor()
        cursor.execute("DELETE FROM products WHERE id = %s", (product_id,))
        PgConfig.pg_commit()
        cursor.close()
        return True
