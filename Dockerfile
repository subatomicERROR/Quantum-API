# Use a base image that supports both Python & Node.js
FROM mcr.microsoft.com/devcontainers/python:3.10

# Install Node.js manually
RUN apt update && apt install -y nodejs npm

# Set environment variables for Hugging Face Spaces compatibility
ENV MPLCONFIGDIR=/tmp/matplotlib
ENV XDG_CACHE_HOME=/tmp/.cache
ENV FONTCONFIG_PATH=/etc/fonts
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install Python dependencies (FastAPI)
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js dependencies (Next.js)
WORKDIR /app/frontend
RUN npm install && npm run build

# Expose port for Hugging Face Spaces
EXPOSE 7860

# Start both FastAPI and Next.js
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 7860 & npm --prefix /app/frontend start"]
