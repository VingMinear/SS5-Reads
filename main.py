from flask import Flask, jsonify, request, send_from_directory, render_template
from werkzeug.utils import secure_filename
# from firebase_admin import credentials, initialize_app

from database.db import PgConfig
from routes.product_route import product_bp
from routes.user_route import user_bp
from routes.favorite_route import favorite_bp
from routes.order_route import order_bp
from routes.route_address import address_bp
from routes.slides_route import slides_bp
import os

app = Flask(__name__)

app.register_blueprint(order_bp, url_prefix='/api/')
app.register_blueprint(product_bp, url_prefix='/api/')
app.register_blueprint(user_bp, url_prefix='/api/')
app.register_blueprint(address_bp, url_prefix='/api/')
app.register_blueprint(favorite_bp, url_prefix='/api/')
app.register_blueprint(slides_bp, url_prefix='/api/')

@app.route('/')
def home():
    return render_template('home.html')


# Set the upload folder and allowed file types
UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Create the upload folder if it doesn't exist
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory('uploads', filename)

#


# cred = credentials.Certificate("path/to/serviceAccountKey.json")
# firebase_admin.initialize_app(cred)


# @app.route('/send-topic-notification', methods=['POST'])
# def send_topic_notification():
#     try:
#         # Parse data from the request
#         data = request.json
#         if not data:
#             return jsonify({"error": "Invalid data"}), 400
#
#         topic = data.get("topic")
#         title = data.get("title", "Default Title")
#         message = data.get("message", "Default Message")
#         additional_data = data.get("data", {})  # Optional custom payload
#
#         if not topic:
#             return jsonify({"error": "No topic provided"}), 400
#
#         # Send notification to the topic
#         result = push_service.notify_topic_subscribers(
#             topic_name=topic,
#             message_title=title,
#             message_body=message,
#             data_message=additional_data
#         )
#
#         return jsonify({"success": True, "response": result}), 200
#
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
#

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
