from flask import Flask, jsonify, request, send_from_directory, render_template
import stripe
from werkzeug.utils import secure_filename
from database.db import PgConfig
from flask_cors import CORS
from routes.product_route import product_bp
from routes.user_route import user_bp
from routes.favorite_route import favorite_bp
from routes.order_route import order_bp
from routes.route_address import address_bp
from routes.slides_route import slides_bp
from routes.stripe_route import stripe_bg
import os

app = Flask(__name__)

# Enable CORS for the app
CORS(app)

app.register_blueprint(order_bp, url_prefix='/api/')
app.register_blueprint(product_bp, url_prefix='/api/')
app.register_blueprint(user_bp, url_prefix='/api/')
app.register_blueprint(address_bp, url_prefix='/api/')
app.register_blueprint(favorite_bp, url_prefix='/api/')
app.register_blueprint(slides_bp, url_prefix='/api/')
app.register_blueprint(stripe_bg, url_prefix='/api/')


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/success')
def success():
    return render_template('success_page.html')


@app.route('/failed_payment')
def failed():
    return render_template('failed.html')


# Set the upload folder and allowed file types
UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50 MB
# Create the upload folder if it doesn't exist
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# for allow to access route photo
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory('uploads', filename)


@app.errorhandler(413)
def request_entity_too_large(e):
    return jsonify({'error': 'File too large. Maximum allowed size is 50MB', 'code': 413}), 413


@app.route('/api/upload-photo', methods=['POST'])
def upload_photo():
    # Check if the request has the file part
    if 'photo' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['photo']

    # If the user does not select a file
    if file.filename == '':
        return jsonify({'error': 'No file selected for uploading'}), 400

    # Check if the file is allowed
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        return jsonify({'message': 'File uploaded successfully', 'file_path': filepath, 'code': 200}), 200
    else:
        return jsonify({'error': 'Allowed file types are png, jpg, jpeg, gif'}), 400


if __name__ == "__main__":
    # Ensure the app is running and PgConfig is ready for queries
    try:
        app.run(port=3000, debug=True)
    finally:
        PgConfig.close()  # Close the database connection when the app stops
