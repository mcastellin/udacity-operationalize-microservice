from locust import HttpLocust, TaskSet, between

SAMPLE_REQUEST = {
    "CHAS": {"0": 0},
    "RM": {"0": 6.575},
    "TAX": {"0": 296.0},
    "PTRATIO": {"0": 15.3},
    "B": {"0": 396.9},
    "LSTAT": {"0": 4.98},
}


def index(l):
    l.client.get("/")


def predict(l):
    l.client.post("/predict", json=SAMPLE_REQUEST)


class PredictionLoadTesting(TaskSet):
    tasks = {index: 1, predict: 2}


class WebsiteUser(HttpLocust):
    task_set = PredictionLoadTesting
    wait_time = between(0, 1)
