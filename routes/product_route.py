from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import os
from controller.product_controller import ProductController

# Define the Blueprint for product routes
product_bp = Blueprint('product', __name__)

# Configure the upload folder and allowed extensions
UPLOAD_FOLDER = 'lib/images'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}


# Function to check if the file is allowed
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# Route for uploading image
@product_bp.route('/upload', methods=['POST'])
def upload_file():
    if 'image' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['image']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(UPLOAD_FOLDER, filename))
        return jsonify({'code': 200, 'message': 'File uploaded successfully', 'profile': filename}), 200
    else:
        return jsonify({'error': 'File type not allowed'}), 400


# Route to get categories
@product_bp.route('/category', methods=['POST'])
def category():
    return ProductController.get_category(request)


# Route to add category
@product_bp.route('/add-category', methods=['POST'])
def add_category_route():
    return ProductController.add_category(request)


# Route to update category
@product_bp.route('/update-category', methods=['POST'])
def update_category_route():
    return ProductController.update_category(request)


# Route to delete category
@product_bp.route('/delete-category', methods=['POST'])
def delete_category_route():
    return ProductController.delete_category(request)


# Route to get products
@product_bp.route('/products', methods=['GET'])
def products():

    return ProductController.get_product(request)


# Route to get product details
@product_bp.route('/products-detail', methods=['POST'])
def product_detail():
    return ProductController.get_product_detail(request)


# Route to add a new product
@product_bp.route('/add-products', methods=['POST'])
def add_product_route():
    return ProductController.add_product(request)


# Route to update product
@product_bp.route('/update-products', methods=['POST'])
def update_product_route():
    return ProductController.update_product(request)


# Route to delete product
@product_bp.route('/delete-products', methods=['POST'])
def delete_product_route():
    return ProductController.delete_product(request)


# Route to get products by category
@product_bp.route('/products-category', methods=['POST'])
def products_by_category():
    return ProductController.get_product_by_category(request)


# Route to search products
@product_bp.route('/products-search', methods=['POST'])
def products_search():
    return ProductController.get_product(request)
