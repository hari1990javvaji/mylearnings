from flask import Flask, request, jsonify
from pymongo import MongoClient
import bson.json_util as json_util
from bson.objectid import ObjectId
import json, os

app = Flask(__name__)
mongo_host_uri='mongodb://' + os.environ['MONGODB_USERNAME'] + ':' + os.environ['MONGODB_PASSWORD'] + '@' + os.environ['MONGODB_HOSTNAME']
# MongoDB connection
client = MongoClient(mongo_host_uri,27017)
#client = MongoClient("localhost",27017)  # Replace with your MongoDB URI
#db = client["mydatabase"]
#db = client.neuraldb
#collection = db.people

mongo_db = os.environ['MONGODB_DATABASE']
db = client[mongo_db]
collection = db["people"]



@app.route("/health")
def health():
    return jsonify(
        status="Application UP.."
    )

@app.route("/create", methods=["POST"])
def create():
    data = request.get_json()
    if data:
        inserted = collection.insert_one(data)
        return jsonify({"message": "Document created successfully", "id": str(inserted.inserted_id)}), 201
    else:
        return jsonify({"message": "Invalid input data"}), 400

@app.route("/read", methods=["GET"])
def read():
    #documents = list(collection.find({},{"_id": 0}))
    documents = list(collection.find({}))
    print(documents)
    json_doc = json.loads(json_util.dumps(documents))
    return jsonify(json_doc), 200

@app.route("/update/<string:id>", methods=["PUT"])
def update(id):
    data = request.get_json()
    print(data)
    if data:
        previous_doc = list(collection.find({"_id": ObjectId(id)}))
        updated = collection.update_one({"_id": ObjectId(id)}, {"$set": data})
        update_doc = list(collection.find({"_id": ObjectId(id)}))
        
        if updated.modified_count > 0:
            return jsonify({"message": "Document updated successfully", "previous_doc": json.loads(json_util.dumps(previous_doc)), "updated_doc": json.loads(json_util.dumps(update_doc))}), 200
        else:
            return jsonify({"message": "Document not found"}), 404
    else:
        return jsonify({"message": "Invalid input data"}), 400

@app.route("/delete/<string:id>", methods=["DELETE"])
def delete(id):
    deleted_doc = list(collection.find({"_id": ObjectId(id)}))
    deleted = collection.delete_one({"_id": ObjectId(id)})
    if deleted.deleted_count > 0:
        return jsonify({"message": "Document deleted successfully", "deleted_doc": json.loads(json_util.dumps(deleted_doc))}), 200
    else:
        return jsonify({"message": "Document not found"}), 404

if __name__ == "__main__":
    #app.run(debug=True)
    #app.run(host='0.0.0.0', port=5000, debug=True)
    ENVIRONMENT_DEBUG = os.environ.get("APP_DEBUG", True)
    ENVIRONMENT_PORT = os.environ.get("APP_PORT", 5000)
    app.run(host='0.0.0.0', port=ENVIRONMENT_PORT, debug=ENVIRONMENT_DEBUG)
