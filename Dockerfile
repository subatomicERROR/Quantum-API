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

# Install Python dependencies (FastAPI & Gradio)
RUN pip install --no-cache-dir -r requirements.txt

# Expose port for FastAPI & Gradio (7860)
EXPOSE 7860

# Start FastAPI
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port 7860"]
