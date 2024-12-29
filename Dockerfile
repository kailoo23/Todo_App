# Use the official Python image as a base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file if needed (optional)
# COPY requirements.txt .

# Install Flask
RUN pip install flask

# Copy the application code into the container
COPY app.py .
COPY templates ./templates

# Expose the port the app runs on
EXPOSE 5000

# Define the command to run the app
CMD ["python", "app.py"]
