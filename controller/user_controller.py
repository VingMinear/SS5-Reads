import hashlib
import os
import secrets

from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import secure_filename
from flask import jsonify, request
from database.db import PgConfig
from psycopg2 import DatabaseError

# Function to check if file is allowed for upload
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


class UserController:
    @staticmethod
    def change_password(user_id):
        data = request.json
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        # Input validation
        if not old_password or not new_password:
            return jsonify({'error': 'Old and new passwords are required', 'code': 400}), 400

        try:
            cursor = PgConfig.get_cursor()

            # Fetch the user’s current password hash from the database
            cursor.execute("SELECT password FROM tbl_user WHERE id = %s", (user_id,))
            user = cursor.fetchone()

            if not user:
                return jsonify({'error': 'User not found', 'code': 404}), 404

            # Check if the old password is correct (using SHA-256)
            hashed_old_password = hashlib.sha256(old_password.encode()).hexdigest()
            if hashed_old_password != user['password']:
                return jsonify({'error': 'Old password is incorrect', 'code': 401}), 401

            # Hash the new password with SHA-256
            hashed_new_password = hashlib.sha256(new_password.encode()).hexdigest()

            # Update the password in the database
            update_query = """
                    UPDATE tbl_user SET password = %s, updated_at = CURRENT_TIMESTAMP
                    WHERE id = %s RETURNING id;
                """
            cursor.execute(update_query, (hashed_new_password, user_id))
            PgConfig.pg_commit()

            # Confirm password update
            if cursor.rowcount == 1:
                return jsonify({'message': 'Password updated successfully', 'code': 200}), 200
            else:
                return jsonify({'error': 'Failed to update password', 'code': 500}), 500

        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e), 'code': 500}), 500
    @staticmethod
    def create_user():
        data = request.json
        try:
            cursor = PgConfig.get_cursor()

            # Check if email already exists
            check_email_query = "SELECT id FROM tbl_user WHERE email = %s"
            cursor.execute(check_email_query, (data['email'],))
            if cursor.fetchone():
                cursor.close()
                return jsonify(
                    {'message': 'This email is already exist please try different account', 'code': 400}), 200

            # Hash password
            hashed_password = hashlib.sha256(data['password'].encode()).hexdigest()

            # Handle photo file upload
            photo = data.get('photo', '')
            if 'photo' in request.files:
                file = request.files['photo']
                if file and allowed_file(file.filename):
                    photo = secure_filename(file.filename)
                    file.save(os.path.join('lib/images', photo))

            # Insert user into the database
            query = """
                INSERT INTO tbl_user (name, email, phone, is_admin, active, password, photo)
                VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id, name, email, phone, is_admin, active, photo;
            """
            cursor.execute(query, (
                data['name'], data['email'], data['phone'], data['is_admin'],
                data['active'], hashed_password, photo
            ))
            PgConfig.pg_commit()

            user = cursor.fetchone()
            cursor.close()
            return jsonify({'message': 'User created successfully', 'data': user, 'code': 200}), 201
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def get_user_by_token():
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token is required', 'code': 401}), 401

        # Strip 'Bearer ' if present in the token
        if token.startswith("Bearer "):
            token = token[len("Bearer "):]

        try:
            cursor = PgConfig.get_cursor()
            query = "SELECT id, name, email, phone, is_admin, active, photo FROM tbl_user WHERE token = %s"
            cursor.execute(query, (token,))
            user = cursor.fetchone()
            cursor.close()

            if user:
                return jsonify({'data': user, 'code': 200}), 200
            return jsonify({'message': 'User not found or invalid token', 'code': 404}), 404
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def get_user_by_id(user_id):
        try:
            cursor = PgConfig.get_cursor()
            query = "SELECT * FROM tbl_user WHERE id = %s"
            cursor.execute(query, (user_id,))
            user = cursor.fetchone()
            cursor.close()

            if user:
                return jsonify({'data': user, 'code': 200}), 200
            return jsonify({'message': 'User not found', 'code': 404}), 404
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def update_photo(user_id):
        data = request.json
        try:
            cursor = PgConfig.get_cursor()

            update_query = """
                UPDATE tbl_user SET photo = %s, updated_at = CURRENT_TIMESTAMP
                WHERE id = %s RETURNING id, name, email, phone, is_admin, active, photo;
            """
            cursor.execute(update_query, (
                data['photo'], user_id
            ))
            PgConfig.pg_commit()

            user = cursor.fetchone()
            cursor.close()

            if user:
                return jsonify({'message': 'User updated successfully', 'data': user, 'code': 200}), 200
            return jsonify({'message': 'User not found', 'code': 404}), 404

        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def update_user(user_id):
        data = request.json
        try:
            cursor = PgConfig.get_cursor()

            # Check if email already exists for another user
            check_email_query = """
                SELECT id FROM tbl_user WHERE email = %s AND id != %s;
            """
            cursor.execute(check_email_query, (data['email'], user_id))
            duplicate_user = cursor.fetchone()

            if duplicate_user:
                cursor.close()
                return jsonify({'message': 'Email is already in use by another user', 'code': 409}), 409

            # Proceed with the update if no duplicate email is found
            update_query = """
                UPDATE tbl_user SET name = %s, email = %s, phone = %s, is_admin = %s,
                    active = %s, updated_at = CURRENT_TIMESTAMP
                WHERE id = %s RETURNING id, name, email, phone, is_admin, active, photo;
            """
            cursor.execute(update_query, (
                data['name'], data['email'], data['phone'], data['is_admin'],
                data['active'], user_id
            ))
            PgConfig.pg_commit()

            user = cursor.fetchone()
            cursor.close()

            if user:
                return jsonify({'message': 'User updated successfully', 'data': user, 'code': 200}), 200
            return jsonify({'message': 'User not found', 'code': 404}), 404

        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def delete_user(user_id):
        try:
            cursor = PgConfig.get_cursor()
            query = "DELETE FROM tbl_user WHERE id = %s RETURNING id;"
            cursor.execute(query, (user_id,))
            PgConfig.pg_commit()

            deleted_user = cursor.fetchone()
            cursor.close()

            if deleted_user:
                return jsonify({'message': 'User deleted successfully', 'code': 200}), 200
            return jsonify({'message': 'User not found', 'code': 404}), 404
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def get_all_users():
        try:
            cursor = PgConfig.get_cursor()
            query = "SELECT id, name, email, phone, is_admin, active, photo FROM tbl_user"
            cursor.execute(query)
            users = cursor.fetchall()
            cursor.close()

            return jsonify({'data': users, 'code': 200}), 200
        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500

    @staticmethod
    def login():
        data = request.json
        try:
            cursor = PgConfig.get_cursor()

            # Check if email exists in the database
            query = "SELECT * FROM tbl_user WHERE email = %s"
            cursor.execute(query, (data['email'],))
            user = cursor.fetchone()

            if user:
                # Check if the user is active
                if not user['active']:
                    cursor.close()
                    return jsonify({'message': 'Your account is currently inactive. Please contact support for assistance or try again later.', 'code': 403}), 403

                # Check password
                hashed_password = hashlib.sha256(data['password'].encode()).hexdigest()
                if hashed_password == user['password']:
                    # Generate a new token for the session
                    token = secrets.token_hex(16)

                    # Update the user's token in the database
                    update_token_query = "UPDATE tbl_user SET token = %s WHERE id = %s"
                    cursor.execute(update_token_query, (token, user['id']))
                    PgConfig.pg_commit()

                    # Include token in response
                    cursor.close()
                    return jsonify({'message': 'Login successful', 'token': token, 'data': user, 'code': 200}), 200
                else:
                    cursor.close()
                    return jsonify({'message': 'Invalid password', 'code': 400}), 400

            cursor.close()
            return jsonify({'message': 'User not found', 'code': 404}), 404

        except DatabaseError as e:
            PgConfig.pg_commit()
            return jsonify({'error': 'Database error', 'details': str(e)}), 500