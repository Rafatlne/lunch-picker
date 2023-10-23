# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Install python-dotenv
RUN pip install python-dotenv

# Copy the initialization script to the container
COPY entrypoint.sh /app/

# Make the script executable
RUN chmod +x /app/entrypoint.sh

# Run the initialization script
CMD ["./entrypoint.sh"]
