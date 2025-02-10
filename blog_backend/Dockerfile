FROM python:slim
WORKDIR /app

COPY requirements.txt .
RUN python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

COPY . .

# Ensure wait-for-it.sh is copied and executable
COPY wait-for-it.sh /app/wait-for-it.sh
RUN chmod +x /app/wait-for-it.sh
