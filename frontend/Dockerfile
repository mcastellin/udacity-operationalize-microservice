
FROM python:3.7.3-stretch

# Environment varialbes for the API endpoint with default values
ENV PREDICTION_API=localhost
ENV PREDICTION_API_PORT=8000

WORKDIR /app
COPY . /app/

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --upgrade pip &&\
      pip install -r requirements.txt

# Expose port 80
EXPOSE 80

# Run app.py at container launch
CMD ["python", "app.py"]
