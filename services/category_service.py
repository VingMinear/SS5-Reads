from database.db import PgConfig


class CategoryService:
    @staticmethod
    def get_all_categories():
        cursor = PgConfig.get_cursor()
        cursor.execute("SELECT * FROM categories")
        categories = cursor.fetchall()
        cursor.close()
        return categories

    @staticmethod
    def add_category(name):
        cursor = PgConfig.get_cursor()
        cursor.execute("INSERT INTO categories (name) VALUES (%s) RETURNING id", (name,))
        category_id = cursor.fetchone()['id']
        PgConfig.pg_commit()
        cursor.close()
        return CategoryService.get_category_by_id(category_id)

    @staticmethod
    def get_category_by_id(category_id):
        cursor = PgConfig.get_cursor()
        cursor.execute("SELECT * FROM categories WHERE id = %s", (category_id,))
        category = cursor.fetchone()
        cursor.close()
        return category
