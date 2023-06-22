# Stage 1: Build the Python app
FROM python:3.6 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the application code to the container
COPY app.py .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Create the final image with Nginx
FROM nginx:latest

# Copy the built Python app from the previous stage
COPY --from=builder /app /app

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx and run the Python app
CMD service nginx start && python /app/app.py
