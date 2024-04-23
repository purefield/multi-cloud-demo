# Use a UBI base image
FROM registry.access.redhat.com/ubi8/ubi:latest

# Install Node.js
RUN yum module enable -y nodejs:14 && \
    yum install -y nodejs && \
    yum clean all

# Create a directory for your application
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of your application code
COPY *.js .

# OpenShift runs containers using an arbitrarily assigned user ID
# Ensure the application directory is writable by this user
RUN chown -R 1001:0 /app && \
    chmod -R g+rwX /app

# Specify the user to run the application (non-root)
USER 1001

# Expose port 3000 for your application
EXPOSE 3000

# Define the command to run your application
CMD ["npm", "start"]
