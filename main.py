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
import os

app = Flask(__name__)

# Enable CORS for the app
CORS(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=True)

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


stripe.api_key = 'sk_test_51PVAzHLRxnMedF0lzFqfkqqqfeXJsMsGiqueXf4v0iFN5u7jiYBhAYlxmdCKerdxwqlrJNkgiDJh7lfAIHNcu24E00Gw9bRSEB'


@app.route('/create-payment-intent', methods=['GET'])
def create_payment_intent():
    try:
        # Extract amount and currency from the request

        amount = request.args.get('amount', 0)
        currency = request.args.get('currency', 'usd')

        # Create a PaymentIntent with the specified amount and currency
        payment_intent = stripe.PaymentIntent.create(
            amount=amount,
            currency=currency,
            # Optionally add payment method options, such as required authentication
        )

        # Return the client secret for the frontend to confirm the payment
        return jsonify({
            'clientSecret': payment_intent.client_secret
        })
    except Exception as e:
        return jsonify(error=str(e)), 500


# for allow to access route photo
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory('uploads', filename)


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
