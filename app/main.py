from flask import Flask, request, jsonify
from management import SpartanManagement
from pymongo import MongoClient
from bson import json_util
import json
import time
import random

server_id = random.randinit(1000, 9999)
app = Flask(__name__)
spartan_management = SpartanManagement()

@app.route('/', methods=["GET"])
def home_page():
    return f"Sparta-Trainee Management System: {server_id}"


@app.route('/spartan/add', methods = ['POST'])
def add_spartan():
    trainee_data = request.json
    spartan_id = trainee_data['spartan_id']
    first_name = trainee_data['first_name']
    last_name = trainee_data['last_name']
    birth_day = trainee_data['birth_day']
    birth_month = trainee_data['birth_month']
    birth_year = trainee_data['birth_year']
    course = trainee_data['course']
    stream = trainee_data['stream']

    result = spartan_management.add_trainee(spartan_id, first_name, last_name, birth_year, birth_month, birth_day, course, stream)
    return result


@app.route('/spartan/<spartan_id>', methods = ['GET'])
def get_spartan(spartan_id):
    return spartan_management.get_trainee(spartan_id)


@app.route('/spartan/remove', methods = ["POST"])
def del_spartan():
    spartan_id = request.args.get('id')
    return spartan_management.remove_trainee(spartan_id)


@app.route('/spartan', methods = ["GET"])
def get_spartans():
    data = jsonify(spartan_management.get_trainees())
    return data


if __name__ == "__main__":
    app.run(port = 8080, host="0.0.0.0")
    #pass
