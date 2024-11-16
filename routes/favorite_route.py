from flask import Blueprint
from controller.favorite_controller import FavoriteController

favorite_bp = Blueprint('favorite', __name__)

favorite_bp.route('/get-favorite', methods=['POST'])(FavoriteController.get_favorite)
favorite_bp.route('/add-favorite', methods=['POST'])(FavoriteController.add_favorite)
favorite_bp.route('/upd-favorite', methods=['POST'])(FavoriteController.update_favorite)
favorite_bp.route('/delete-favorite', methods=['POST'])(FavoriteController.delete_favorite)
