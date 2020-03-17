import unittest
import json
from sklearn.externals import joblib

import app

BASE_URL = "http://127.0.0.1/"
PREDICT_URL = f"{BASE_URL}/predict"

PREDICTION_REQUEST = {
    "CHAS": {"0": 0},
    "RM": {"0": 6.575},
    "TAX": {"0": 296.0},
    "PTRATIO": {"0": 15.3},
    "B": {"0": 396.9},
    "LSTAT": {"0": 4.98},
}


class TestFlaskApi(unittest.TestCase):
    def setUp(self):
        app.clf = joblib.load("./model_data/boston_housing_prediction.joblib")
        self.app = app.app.test_client()
        self.app.Testing = True

    def test_get_homepage(self):
        response = self.app.get(BASE_URL)
        self.assertEqual(response.status_code, 200)

    def test_make_prediction(self):
        print(PREDICTION_REQUEST)
        print(PREDICT_URL)
        response = self.app.post(
            PREDICT_URL,
            data=json.dumps(PREDICTION_REQUEST),
            content_type="application/json",
        )
        prediction = json.loads(response.get_data())
        print(prediction)


if __name__ == "__main__":
    unittest.main()
