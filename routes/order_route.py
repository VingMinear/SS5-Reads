from flask import Blueprint
from controller.order_controller import OrderController  # Ensure the correct import path

# Create a blueprint for order routes
order_bp = Blueprint('order', __name__)

# Old route style as per Express.js migration
order_bp.route('/admin-home', methods=['POST'])(OrderController.get_home_api)
order_bp.route('/admin-update-order', methods=['POST'])(OrderController.update_order)
order_bp.route('/admin-order', methods=['POST'])(OrderController.get_order_admin)
order_bp.route('/order', methods=['POST'])(OrderController.get_order)
order_bp.route('/add-order', methods=['POST'])(OrderController.add_order)
order_bp.route('/update-order', methods=['POST'])(OrderController.update_order)
