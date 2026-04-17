from flask import Flask
import redis
import os
from datetime import datetime

app = Flask(__name__)

redis_host = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

message = os.getenv("APP_MESSAGE", "Docker Demo")

@app.route("/")
def home():
    count = r.incr("visitor_count")

    log_line = f"{datetime.now()} - Visitor count: {count}\n"
    with open("/logs/access.log", "a") as f:
        f.write(log_line)

    return f"""
<h1>{message}</h1>
<h2>Visitor Count: {count}</h2>
<p>Containerized app is working successfully.</p>
"""

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
