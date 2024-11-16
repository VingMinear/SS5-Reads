from flask import Blueprint, request
from util.utils import HelperResponse

home_bp = Blueprint('home_bp', __name__)

@home_bp.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'GET':
        data = "hello world"
        return HelperResponse.success(data)
