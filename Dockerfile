# Stage 1: Build the React app
FROM node:16 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the React app
FROM node:16

# Set the working directory
WORKDIR /app

# Copy only the build output from the previous stage
COPY --from=build /app/build /app/build

# Install a simple HTTP server to serve the build files
RUN npm install -g serve

# Expose port 3000 for the React app
EXPOSE 3000

# Start the React app
CMD ["serve", "-s", "build", "-l", "3000"]
