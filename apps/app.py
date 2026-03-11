from flask import Flask
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "hello_app_requests_total",
    "Total number of requests to hello-app"
)

@app.route("/")
def hello():
    REQUEST_COUNT.inc()
    return "Hello from Jenkins on GKE!"

@app.route("/health")
def health():
    return "ok", 200

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)