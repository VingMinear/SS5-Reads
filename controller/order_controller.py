import logging

from flask import request, jsonify
from database.db import PgConfig  # Assuming PgConfig is your database configuration
from util.utils import query, HelperResponse


class OrderController:

    @staticmethod
    def get_order():
        try:
            customer_id = request.json['customer_id']

            # Constructing the SQL query to fetch orders
            sql = f"""
            SELECT DISTINCT ord.ord_id, ord.total_amount, ordS.status, ordD.order_date AS "date"
            FROM tbl_order ord
            INNER JOIN tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
            INNER JOIN tbl_product p ON p.product_id = ordD.product_id
            INNER JOIN tbl_order_status ordS ON ordS.id = ord.status_id
            WHERE ord.customer_id = {customer_id} ORDER BY ordD.order_date DESC;
            """

            # Execute the query
            orders = query(sql)

            if orders:
                for ord in orders:
                    # Construct the SQL query to fetch products for each order
                    sql_products = f"""
                    SELECT ordD.qty, ordD.amount, p.product_name, p.image
                    FROM tbl_order ord
                    INNER JOIN tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
                    INNER JOIN tbl_product p ON p.product_id = ordD.product_id
                    WHERE ord.ord_id = {ord['ord_id']};
                    """
                    print(sql_products)

                    # Execute the product query
                    products = query(sql_products)
                    ord['products'] = products

            # Return the orders as a JSON response
            return HelperResponse.success(orders)

        except Exception as e:
            # Log the error for debugging purposes
            logging.error(f"Error occurred while getting orders: {e}")

            # Return a generic error response
            return jsonify({"error": "An error occurred while fetching the orders."}), 500

    @staticmethod
    def get_order_admin():
        try:
            # Extract `status_id` and `order_id` from the request data
            status_id = request.json.get('status_id')
            order_id = request.json.get('order_id')
            print(f"status {status_id} , {order_id}")
            if order_id:
                sql = """
               SELECT 
    orders.*, 
    ad.latlng
FROM (
    SELECT DISTINCT 
        ord.ord_id, 
        ord.total_amount, 
        ord.payment_type,
        ordS.status, 
        ordD.order_date AS "date", 
        ad.phone_number, 
        ad.receiver_name, 
        ad.province, 
        ad.commune, 
        ad.district, 
        ad.house
    FROM 
        tbl_order ord
    INNER JOIN 
        tbl_address ad ON ad.customer_id = ord.customer_id
    INNER JOIN 
        tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
    INNER JOIN 
        tbl_product p ON p.product_id = ordD.product_id
    INNER JOIN 
        tbl_order_status ordS ON ordS.id = ord.status_id
    WHERE 
        ord.ord_id = %s 
        AND ad.id = ord.address_id
    ORDER BY 
        ordD.order_date DESC
) AS orders
INNER JOIN 
    tbl_address ad ON ad.phone_number = orders.phone_number;

                """
                orders = query(sql, (order_id,))
            else:
                sql = f"""
                SELECT 
    orders.*, 
    ad.latlng
FROM (
    SELECT DISTINCT 
        ord.ord_id, 
        ord.total_amount, 
        ord.payment_type,
        ordS.status, 
        ordD.order_date AS "date", 
        ad.phone_number, 
        ad.receiver_name, 
        ad.province, 
        ad.commune, 
        ad.district, 
        ad.house
    FROM 
        tbl_order ord
    INNER JOIN 
        tbl_address ad ON ad.customer_id = ord.customer_id
    INNER JOIN 
        tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
    INNER JOIN 
        tbl_product p ON p.product_id = ordD.product_id
    INNER JOIN 
        tbl_order_status ordS ON ordS.id = ord.status_id
    WHERE 
        ord.status_id = {status_id} 
        AND ad.id = ord.address_id
    ORDER BY 
        ordD.order_date DESC
) AS orders
INNER JOIN 
    tbl_address ad ON ad.phone_number = orders.phone_number;
                """

                orders = query(sql)
            # Process each order to add products
            for order in orders:
                sql_products = """
                SELECT ordD.qty, ordD.amount, p.product_name, p.image
                FROM tbl_order ord
                INNER JOIN tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
                INNER JOIN tbl_product p ON p.product_id = ordD.product_id
                WHERE ord.ord_id = %s;
                """
                products = query(sql_products, (order['ord_id'],))
                order['products'] = products if isinstance(products, list) else []

            return jsonify({'message': 'Orders fetched successfully', 'data': orders, 'code': 200}), 200

        except Exception as e:
            # Log or print the exception for debugging purposes
            print("Error in get_order_admin:", str(e))
            return jsonify({'message': 'Database error', 'details': str(e), 'code': 500}), 500

    @staticmethod
    def get_home_api():
        sql = """
        SELECT count(*) AS order_count 
        FROM tbl_order ord
        INNER JOIN tbl_address ad ON ad.customer_id = ord.customer_id
        INNER JOIN tbl_order_detail ordD ON ord.ord_id = ordD.ord_id
        INNER JOIN tbl_product p ON p.product_id = ordD.product_id
        INNER JOIN tbl_order_status ordS ON ordS.id = ord.status_id
        WHERE ord.status_id = 1 AND ad.id = ord.address_id;
        """
        print(sql)
        order_count = query(sql)
        return jsonify({'order_count': order_count[0]['order_count'],'code':200}), 200

    @staticmethod
    def add_order():
        try:
            data = request.json
            customer_id = data.get('customer_id')
            status_id = data.get('status_id')
            seller = data.get('seller')
            discount = data.get('discount')
            current_date = data.get('currentDate')
            payment_type = data.get('payment_type')
            products = data.get('products')
            device_id = data.get('device_id')
            total_amount = data.get('total_amount')
            customer_name = data.get('customer_name')
            address_id = data.get('address_id')

            # Insert new order with RETURNING to get order_id from PostgreSQL
            sql = f"""
               INSERT INTO tbl_order(customer_id, customer_name, device_id, payment_type, status_id, seller, discount, total_amount, address_id)
               VALUES ({customer_id}, '{customer_name}', '{device_id}', '{payment_type}', {status_id}, '{seller}', {discount}, {total_amount}, {address_id}) RETURNING ord_id;
            """
            result = query(sql)

            order_id = result[0]['ord_id']


            units = 0
            for item in products:
                pro_qty = 0
                old_sold = 0
                product = query(f"SELECT * FROM tbl_product WHERE product_id = {item['product_id']}")

                if product[0]['qty'] is not None:
                    pro_qty = product[0]['qty']
                if product[0]['sold'] is not None:
                    old_sold = product[0]['sold']

                if pro_qty <= 0:

                    query(f"DELETE FROM tbl_order WHERE ord_id = {order_id}")
                    return jsonify({'message': 'Product out of stock!'}), 400

                if item['qty'] > pro_qty:
                    print(f'low')
                    return jsonify({'message': f"Product quantity is not sufficient.\n Available: {pro_qty}.","code":400}), 400
                print(f"hererr {product[0]}")
                amount = item['price'] * item['qty']
                qty = pro_qty - item['qty']
                new_sold = old_sold + item['qty']
                units += item['qty']

                # Update product quantities and sold numbers
                query(f"UPDATE tbl_product SET sold = {new_sold}, qty = {qty} WHERE product_id = {item['product_id']}")

                # Insert into tbl_order_detail
                query(f'''
                   INSERT INTO tbl_order_detail(ord_id, product_id, qty, amount, order_date)
                   VALUES ({order_id}, {item['product_id']}, {item['qty']}, {amount}, '{current_date}');
                ''')

            # # Insert into sale report
            # query(f"""
            #    INSERT INTO tbl_sale_report (customer_name, units, payment_type, amount_sale, date)
            #    VALUES ('{customer_name}', {units}, '{payment_type}', {total_amount}, '{current_date}');
            # """)

            return jsonify({'message': 'Order placed successfully', 'code': 200}), 201

        except Exception as e:
            print(f"Error: {str(e)}")
            return jsonify({'message': 'An error occurred while placing the order', 'error': str(e)}), 500

    @staticmethod
    def update_order():
        data = request.json
        order_id = data.get('order_id')
        status_id = data.get('status_id')
        sql = f"SELECT device_id FROM tbl_order WHERE ord_id = {order_id}"
        order = query(sql)

        status_map = {
            1: "Pending 💨📦",
            2: "Processing 🤞🏻📦",
            3: "Delivering 🚚 📦",
            4: "Completed ✅❤",
            5: "Cancelled ❌💔"
        }

        status_res = status_map.get(status_id, "Unknown status")
        query("UPDATE tbl_order SET status_id = %s WHERE ord_id = %s", (status_id, order_id))

        # # Send notification
        # push_notification({
        #     'priority': 'high',
        #     'notification': {
        #         'title': f"Your order is {status_res}",
        #         'body': f"Your order has been {status_res}.",
        #         'icon': 'app_logo',
        #         'android_channel_id': 'high_importance_channel'
        #     },
        #     'to': order[0]['device_id']
        # })

        return jsonify({'message': f'Order status updated to {status_res}' ,'code':200}), 200
