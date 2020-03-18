[![CircleCI](https://circleci.com/gh/mcastellin/udacity-operationalize-microservice.svg?style=svg)](https://circleci.com/gh/mcastellin/udacity-operationalize-microservice)

## Project Overview

This project contains an operationalized Machine Learning Microservice API, a pre-trained `sklearn` model that predicts housing prices
in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. 
You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing).

As part of the Udacity Cloud DevOps Nanodegree program, 
students have been provided with a machine learning API written in Python. The goal of this excercise is to prepare the application to:
- Install and run in a Docker container
- Create bash scripts to automatically generate and upload containers in a public registry
- Configure and run the application in a Kubernetes cluster
- Integrate a CI build with CircleCI to perform linting and regression testing


## Setup the Environment

To run this project you need to have Python3 and Docker with Kubernetes installed and a MacOs/Linux OS. We use `make` to build and run the code.

First make sure you create Python virtual environment for your local development. Run 
```bash
make setup install-dev
```

Then source your newly created virtual environment with `source ~/.devops/bin/activate`

## Building and Testing Applications

This project contains two Python Flask applications: `api/` and `frontend/`. Linting and unit testing steps are configured in the Makefile.
To verify the application run `make lint test-api`. 

To build Docker images, two Dockerfiles are provided:
- `Dockerfile` under project directory contains build steps for the API application
- `frontend/Dockerfile` contains the build steps to create the fronted application container

## Running the Code

### Run for development

For local development you can simply run the application with your local python environment from the repository home:
```bash
source ~/.devops/bin/activate 
python api/app.py
```

To run a smaple prediction, you can use the `make_prediction.sh` provided. `PORT=80 ./make_prediction.sh`

### Run prediction API with docker

In a terminal window, run `./run_docker.sh`. The script will build the docker image in your local registry and start the container.
By default the container http port is bound to port `8000`

When the container started your should see the following output:
```bash
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 226-693-204
```

You are now ready to run a prediction. In a separate terminal window, run `./make_prediction.sh`

### Run frontend with docker

To run the frontend application a separate script is provided under the `frontend/` directory: `frontend/run_docker.sh`.

The application will start and bind to port 8080. To test the application navigate to `http://localhost:8080/`

### Upload generated images in docker hub

The generated docker images can be pushed to the public registry in Docker Hub with the `upload_docker.sh` command. Simply run:
```bash
./upload_docker.sh
frontend/upload_docker.sh
```

WARNING: scripts are configured to upload under the maintainer's account `mcastellin` so you need an access key to `docker login` successfully.

## Run application in Kubernetes

The application docker images are already deployed to the public registry and you can run thse images in a Kubernetes cluster.

#### `run_kubernetes.sh`

This script will run the api with `kubectl`.
- creates and start a pod to run the prediction API
- exposes the API by forwarding local port `8000 -> 80`

#### `run_kubernetes_stack.sh`

Will run both API and Frontend application in a kubernetes cluster. 
- applies the `api/deploy.yaml` and `frontend/deploy.yaml` to the cluster to created deployments and services
- exposes the `makeprediction-frontend` service by forwarding local port `8080 z-> 80`

#### `run_kubernetes_autoscale.sh`

A utility script to run the make-prediction API service with Kubernetes HPA (Horizontal Pod Autoscaling) configuration and exposes the service 
by forwarding local port `8000 -> 80`.

To watch a demo of the Kubernetes autoscaling functionality click on the image below

![K8s Autoscaling](/img/autoscaling_test.gif)

## Run Load Testing with Locust

A `locustfile.py` is provided to run load test the application and test Kubernetes HPA rules. To run the test with locust follow these instructions.
- run the `./run_kubernetes_autoscale.sh`
- in a new terminal window launch Locust by running `locust` from project home directory
```bash
source ~/.devops/bin/activate
locust
[2020-03-17 19:23:34,576] /INFO/locust.main: Starting web monitor at http://*:8089
[2020-03-17 19:23:34,576] /INFO/locust.main: Starting Locust 0.14.5
```
- locust server is now running at port `8089`. Open your browser and navigate to `http://localhost:8089/`
- configure the locust run by setting total users, hatch rate, and use `http://localhost:8000` as host.
- click the *Start swarming* button to start the load testing

![Locust homepage](/img/locust_home.png)

![Locust chart](/img/locust_chart.png)


## Cleaning up Kubernetes Resources

Run this from command line to delete all the kubernetes resources created by this project
```bash
kubectl delete -f api/deploy.yaml -f frontend/deploy.yaml
kubectl delete pod/makepredictionapp
kubectl delete hpa/makeprediction-api
```

## Repository Structure

Here is a brief summary of the files in this repository and what they are for


#### `api/`

The `api/` directory contains python code and tests for the prediction API Flask application.
- `app.py` and `app_test.py` contains the application code and respective tests
- `deploy.yaml` is a kubernetes definition file to deploy the API application kubernetes stack


#### `frontend/`

The `frontend/` directory contains python code and tests for the frontend Flask application.
- `app.py` contains the application code
- `deploy.yaml` is a kubernetes definition file to deploy the frontend application kubernetes stack
- `run_docker.sh` a bash script to run the frontend application in a docker container
- `upload_docker.sh` upload the generated docker image in docker hub account


#### `run_docker.sh`

Build and runs the Machine Learning Prediction API in a docker container.


#### `upload_docker.sh`

A bash script to upload the generated image for the prediction API to the docker hub account.


#### `run_kubernetes.sh`

Runs the predictions API Flask application as a pod in the kubernetes cluster:
- Runs the predictions API application
- Exposes pod's port with local forwarding


#### `run_kubernetes_stack.sh`

Runs the predictions API and frontend applications stacks in the kubernetes cluster:
- runs api application
- runs frontend application
- exposes frontend kubernetes service with local port forwarding


#### `run_kubernetes_autoscale.sh`

Runs the predictions API application in kubernetes with horizontal pod autoscaling:
- runs prediction API application
- configures autoscaling for kubernetes deployment
- exposes API application service with local port forwarding


#### `make_prediction.sh`

Makes a call to the prediction API and prints out the result received from the server


#### `locustfile.py`

The `locustfile.py` contains the code for `locust` to perform load testing on the application


#### `requirements.txt` and `requirements-dev.txt`

List of Python requirements to run the application for docker containers and development


#### `model_data/`

Contains the trained model for the application to make predictions on Boston house prices


#### `output_txt_files/`

Contains files with the captured outputs for the excercise evaluation

