# Build stage (just so yall understand im gonna slap the comments on rq)
FROM nixos/nix AS builder

# Set working directory inside the builder container
WORKDIR /usr/src/rafka

# Copy the project files into the container
COPY . .

# Install Rust, Cargo, and GCC
RUN nix-env -iA nixpkgs.rustc nixpkgs.cargo nixpkgs.gcc

# Build the project in release mode
RUN cargo build --release

# Final stage: Use a minimal NixOS image as base
FROM nixos/nix

# Copy the built application from the builder stage
COPY --from=builder /usr/src/rafka/target/release/rafka /usr/local/bin/rafka

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["rafka"]