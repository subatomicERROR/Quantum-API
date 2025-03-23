# Use a lightweight Python image
FROM python:3.10-slim

# Set environment variables to fix Matplotlib and Fontconfig issues
ENV MPLCONFIGDIR=/tmp/matplotlib
ENV XDG_CACHE_HOME=/tmp/.cache
ENV FONTCONFIG_PATH=/etc/fonts
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Fix permissions for Matplotlib and Fontconfig
RUN mkdir -p /tmp/matplotlib /tmp/.cache && chmod -R 777 /tmp

# Expose the correct port for FastAPI
EXPOSE 5000

# Start FastAPI with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
