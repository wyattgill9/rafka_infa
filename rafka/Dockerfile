# Stage 1: Build the application using a Rust image
FROM rust:1.82-alpine as builder

# Install necessary dependencies for building the application
RUN apk add --no-cache musl-dev

# Set the working directory
WORKDIR /usr/src/rafka

# Copy the project files into the container
COPY . .

# Configure Cargo to statically link the binary
RUN cargo build --release --target x86_64-unknown-linux-musl

# Stage 2: Create the minimal runtime image using Alpine
FROM alpine:latest

# Install musl (needed for static linking) and SSL libraries (libssl3 instead of libssl1.1)
RUN apk add --no-cache \
    libssl3 \
    ca-certificates

# Copy the statically linked binary from the builder stage
COPY --from=builder /usr/src/rafka/target/x86_64-unknown-linux-musl/release/rafka /usr/local/bin/rafka

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["/usr/local/bin/rafka"]
