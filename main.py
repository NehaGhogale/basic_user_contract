import json
from compile_solidity_utils import w3
from flask import Flask, Response, request, jsonify
from marshmallow import Schema, fields, ValidationError

def check_gender(data):
    valid_list = ["male", "female"]
    if data not in valid_list:
        raise ValidationError(
            'Invalid gender. Valid choices are'+ valid_list
        )

class UserSchema(Schema):
    name = fields.String(required=True)
    gender = fields.String(required=True, validate=check_gender)


app = Flask(__name__)


# api to set new user every api call
@app.route("/blockchain/user", methods=['POST'])
def transaction():
    
    w3.eth.defaultAccount = w3.eth.accounts[1]
    with open("data.json", 'r') as f:
        datastore = json.load(f)
    abi = datastore["abi"]
    contract_address = datastore["contract_address"]

    # Create the contract instance with the newly-deployed address
    user = w3.eth.contract(
        address=contract_address, abi=abi,
    )
    body = request.get_json()
    result, error = UserSchema().load(body)
    if error:        
        return jsonify(error), 422
    tx_hash = user.functions.setUser(
        result['name'], result['gender']
    )
    tx_hash = tx_hash.transact()
    # Wait for transaction to be mined...
    w3.eth.waitForTransactionReceipt(tx_hash)
    user_data = user.functions.getUser().call()
    return jsonify({"data": user_data}), 200

