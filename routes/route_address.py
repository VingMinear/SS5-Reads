from flask import Blueprint
from controller.address_controller import AddressController  # Ensure correct import

address_bp = Blueprint('address', __name__)

# Old route style as per Express.js migration
address_bp.route('/get-address', methods=['POST'])(AddressController.get_address)
address_bp.route('/upd-address', methods=['POST'])(AddressController.update_address)
address_bp.route('/add-address', methods=['POST'])(AddressController.add_address)
address_bp.route('/delete-address', methods=['POST'])(AddressController.delete_address)
