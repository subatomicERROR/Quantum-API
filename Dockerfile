# Use a lightweight Python image
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the correct port for FastAPI
EXPOSE 5000

# Start FastAPI with Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
