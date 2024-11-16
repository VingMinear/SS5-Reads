from flask import Blueprint, request
from controller.user_controller import UserController

# Define the Blueprint for user routes
user_bp = Blueprint('user', __name__)


# Route to create a user
@user_bp.route('/create', methods=['POST'])
def create_user():
    return UserController.create_user()


# Route to get a user by ID
@user_bp.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    return UserController.get_user_by_id(user_id)


@user_bp.route('/users-photo/<int:user_id>', methods=['POST'])
def update_photo(user_id):
    return UserController.update_photo(user_id)


@user_bp.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    return UserController.update_user(user_id)


# Route to delete a user
@user_bp.route('/users-delete/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    return UserController.delete_user(user_id)


# Route to get all users
@user_bp.route('/users', methods=['GET'])
def get_all_users():
    return UserController.get_all_users()


@user_bp.route('/user', methods=['GET'])
def user():
    return UserController.get_user_by_token()


@user_bp.route('/change-pwd/<int:user_id>', methods=['POST'])
def change_password(user_id):
    return UserController.change_password(user_id)


@user_bp.route('/login', methods=['POST'])
def login():
    return UserController.login()
