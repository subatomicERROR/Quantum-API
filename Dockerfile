# Use a base image that supports Python
FROM mcr.microsoft.com/devcontainers/python:3.10

# Set environment variables for Hugging Face Spaces compatibility
ENV MPLCONFIGDIR=/tmp/matplotlib
ENV XDG_CACHE_HOME=/tmp/.cache
ENV FONTCONFIG_PATH=/etc/fonts
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt

# Expose ports for FastAPI (7860) & Gradio (7861)
EXPOSE 7860 7861

# Create Supervisor configuration file
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "[program:fastapi]" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "command=uvicorn app:app --host 0.0.0.0 --port 7860" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "[program:gradio]" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "command=python frontend.py" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor to run FastAPI and Gradio together
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
