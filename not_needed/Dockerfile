FROM alpine:latest

# Install build dependencies
RUN apk update && apk add --no-cache python3.10-dev build-base

# Set working directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt .

# Install pip
RUN python3.10 -m pip install --upgrade pip

# Copy application code
COPY . .

# Expose port (if needed)
# EXPOSE 8000

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
