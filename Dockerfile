# Use a lightweight Python and Node.js image
FROM python:3.10-slim AS backend
FROM node:18-slim AS frontend

# Set environment variables to fix Matplotlib and Fontconfig issues
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

# Fix permissions for Matplotlib and Fontconfig
RUN mkdir -p /tmp/matplotlib /tmp/.cache && chmod -R 777 /tmp

# --- FRONTEND (Next.js) ---
WORKDIR /app/frontend

# Install Next.js dependencies
RUN npm install

# Build Next.js app
RUN npm run build

# --- BACKEND (FastAPI) ---
WORKDIR /app

# Expose the correct port for Hugging Face Spaces (7860)
EXPOSE 7860

# Start FastAPI and Next.js together using a process manager
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 7860 & npm --prefix frontend run start"]
