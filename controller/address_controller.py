from flask import request, jsonify
from database.db import PgConfig
from util.utils import query, query_condition  # Assuming query functions are in utils


class AddressController:

    @staticmethod
    def get_address():
        customer_id = request.json.get('customer_id')

        if not customer_id:
            return jsonify({'message': 'Customer ID is required'}), 400

        # Query the database to fetch the address data for the customer (filtering soft-deleted addresses)
        sql = "SELECT * FROM tbl_address WHERE customer_id = %s AND is_delete = FALSE"
        result = query(sql, (customer_id,))

        if not result:
            return jsonify({'message': 'No addresses found for this customer', 'code': 200}), 200

        return jsonify({'message': 'Addresses fetched successfully', 'data': result, 'code': 200}), 200

    @staticmethod
    def add_address():
        data = request.json
        required_fields = ['customer_id', 'receiver_name', 'phone_number', 'district', 'province', 'commune', 'house']

        # Check if all required fields are present
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({'message': f'Missing required fields: {", ".join(missing_fields)}'}), 400

        # Handle optional latitude and longitude
        latitude = data.get('latitude')
        longitude = data.get('longitude')

        # Prepare the query to insert the new address
        sql = """
            INSERT INTO tbl_address (customer_id, receiver_name, phone_number, province, district, commune, house, latlng)
            VALUES (%s, %s, %s, %s, %s, %s, %s, 
                    CASE WHEN %s IS NOT NULL AND %s IS NOT NULL THEN POINT(%s, %s) ELSE NULL END);
        """
        params = (
            data['customer_id'],
            data['receiver_name'],
            data['phone_number'],
            data['province'],
            data['district'],
            data['commune'],
            data['house'],
            latitude,  # Used in CASE WHEN
            longitude,  # Used in CASE WHEN
            latitude,  # Used in POINT()
            longitude  # Used in POINT()
        )

        # Execute the query
        query_condition(sql, params)

        return jsonify({'message': 'Address added successfully', 'code': 200}), 200

    @staticmethod
    def update_address():
        data = request.json
        address_id = data.get('id')
        required_fields = ['receiver_name', 'phone_number', 'province', 'commune', 'house']

        # Validate required fields
        if not address_id:
            return jsonify({'message': 'Address ID is required'}), 400

        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({'message': f'Missing required fields: {", ".join(missing_fields)}'}), 400

        # SQL query to update the address (only if it is not soft-deleted)
        sql = """
            UPDATE tbl_address
            SET receiver_name = %s, phone_number = %s, province = %s, commune = %s, house = %s
            WHERE id = %s AND is_delete = FALSE;
        """
        params = (
            data['receiver_name'],
            data['phone_number'],
            data['province'],
            data['commune'],
            data['house'],
            address_id
        )

        # Execute the query
        query_condition(sql, params)

        return jsonify({'message': 'Address updated successfully', 'code': 200}), 200

    @staticmethod
    def delete_address():
        data = request.json
        address_id = data.get('id')

        if not address_id:
            return jsonify({'message': 'Address ID is required'}), 400

        # SQL query to mark the address as deleted (soft delete) by setting is_delete = TRUE
        sql = "UPDATE tbl_address SET is_delete = TRUE WHERE id = %s AND is_delete = FALSE;"
        query_condition(sql, (address_id,))

        return jsonify({'message': 'Address marked as deleted successfully', 'code': 200}), 200
