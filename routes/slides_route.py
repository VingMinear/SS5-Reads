from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import os
from controller.slides_controller import SlidesController

# Define the Blueprint for product routes
slides_bp = Blueprint('slides', __name__)


@slides_bp.route('/slides', methods=['POST'])
def slides():
    return SlidesController.get_slides(request)


# Route to add slides
@slides_bp.route('/add-slides', methods=['POST'])
def add_slides_route():
    return SlidesController.add_slides(request)


# Route to update slides
@slides_bp.route('/update-slides', methods=['POST'])
def update_slides_route():
    return SlidesController.update_slides(request)


# Route to delete slides
@slides_bp.route('/delete-slides', methods=['POST'])
def delete_slides_route():
    return SlidesController.delete_slides(request)