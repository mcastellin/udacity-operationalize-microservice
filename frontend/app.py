from flask import Flask, request, render_template, abort
from flask.logging import create_logger
import logging

import requests
import os
import json

app = Flask(__name__)
LOG = create_logger(app)
LOG.setLevel(logging.INFO)

PREDICTION_SERVICE = os.getenv("PREDICTION_API", "localhost")
PREDICTION_SERVICE_PORT = os.getenv("PREDICTION_API_PORT", "8000")

API_URL = f"http://{PREDICTION_SERVICE}:{PREDICTION_SERVICE_PORT}/predict"


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/prediction", methods=["POST"])
def make_prediction():
    form = request.form
    LOG.info(f"Received form data: {form}")

    payload = {
        "CHAS": {"0": int(form["chas"])},
        "RM": {"0": float(form["rm"])},
        "TAX": {"0": float(form["tax"])},
        "PTRATIO": {"0": float(form["ptratio"])},
        "B": {"0": float(form["b"])},
        "LSTAT": {"0": float(form["lstat"])},
    }

    api_response = requests.post(
        API_URL, json=payload, headers={"Content-Type": "application/json"}
    )

    if api_response.status_code != 200:
        return abort(500)

    response_json = json.loads(api_response.text)
    LOG.info(f"Received prediction api response: {response_json}")

    return render_template(
        "prediction.html", prediction=json.dumps(response_json["prediction"])
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)
