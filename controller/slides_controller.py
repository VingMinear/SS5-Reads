from flask import request, jsonify
from database.db import PgConfig
from util.utils import query, query_condition, HelperResponse  # Assuming query functions are in utils


class SlidesController:

    @staticmethod
    def get_slides(req):
        try:
            sql = "SELECT * FROM tbl_slides;"
            result = query(sql)
            return HelperResponse.success(result)
        except Exception as e:
            return HelperResponse.error("Failed to fetch tbl_slides", str(e))

    @staticmethod
    def add_slides(request):
        data = request.json
        title = data.get("title")
        image = data.get("image")
        try:
            sql = f"INSERT INTO tbl_slides (title, image) VALUES ('{title}', '{image}');"
            query_condition(sql)
            return HelperResponse.success("Slides added successfully")
        except Exception as e:
            return HelperResponse.error("Failed to add slides", str(e))

    @staticmethod
    def update_slides(request):
        data = request.json
        id = data.get("id")
        title = data.get("title")
        image = data.get("image")
        try:
            sql = f"UPDATE tbl_slides SET title = '{title}', image = '{image}' WHERE id = {id};"
            query_condition(sql)
            return HelperResponse.success("Slides updated successfully")
        except Exception as e:
            return HelperResponse.error("Failed to update slides", str(e))

    @staticmethod
    def delete_slides(request):
        id = request.json.get("id")
        try:
            sql = f"DELETE FROM tbl_slides WHERE id = {id};"
            query_condition(sql)
            return HelperResponse.success("Slides deleted successfully")
        except Exception as e:
            return HelperResponse.error("Failed to delete slide", str(e))
