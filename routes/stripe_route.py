import os
import stripe
from flask import Blueprint, jsonify, request

# Create a blueprint for stripe routes
stripe_bg = Blueprint('stripe', __name__)

# Set Stripe secret key (use an environment variable for security)
stripe.api_key = os.getenv('STRIPE_SECRET_KEY',
                           'sk_test_51PVAzHLRxnMedF0lzFqfkqqqfeXJsMsGiqueXf4v0iFN5u7jiYBhAYlxmdCKerdxwqlrJNkgiDJh7lfAIHNcu24E00Gw9bRSEB')


@stripe_bg.route('/create-checkout-session', methods=['POST'])
def create_checkout_session():
    try:
        # Get data from the request
        data = request.json
        if not data:
            raise ValueError("Missing request data")

        amount = data.get("amount")  # Amount in cents
        currency = data.get("currency", "usd")
        success_url = data.get("success_url", "http://ss5reads.jonward.com/success")
        cancel_url = data.get("cancel_url", "http://ss5reads.jonward.com/failed_payment")

        if not amount:
            raise ValueError("Amount is required")

        # Create a Checkout Session
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': currency,
                    'product_data': {
                        'name': 'Your Product',
                    },
                    'unit_amount': int(amount),
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=success_url,
            cancel_url=cancel_url,
        )

        return jsonify({"url": session.url})
    except stripe.error.StripeError as e:
        # Handle Stripe API errors
        return jsonify({"error": f"Stripe error: {e.user_message}"}), 400
    except ValueError as e:
        # Handle validation errors
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        # Handle all other errors
        return jsonify({"error": "An unexpected error occurred"}), 500
