#!/bin/bash

echo "Welcome to the Password Generator!"

# Ask for length
read -p "Enter password length: " length

# Ask for type
echo "Choose character set:"
echo "1) Letters only"
echo "2) Letters + Numbers"
echo "3) Letters + Numbers + Symbols"
read -p "Enter choice (1-3): " choice

# Ask for optional hashing
echo "Optional: hash password?"
echo "1) None"
echo "2) MD5"
echo "3) SHA256"
read -p "Enter choice (1-3): " hash_choice

# Determine charset
case $choice in
  1) charset='A-Za-z' ;;
  2) charset='A-Za-z0-9' ;;
  3) charset='A-Za-z0-9!@#$%^&*()_+-=~' ;;
  *) echo "Invalid choice, defaulting to Letters + Numbers"; charset='A-Za-z0-9' ;;
esac

# Generate password
password=$(tr -dc "$charset" < /dev/urandom | head -c $length)

# Apply hash if requested
case $hash_choice in
  1) final_password="$password" ;;
  2) final_password=$(echo -n "$password" | md5sum | awk '{print $1}') ;;
  3) final_password=$(echo -n "$password" | sha256sum | awk '{print $1}') ;;
  *) final_password="$password" ;;
esac

echo "Generated Password: $final_password"
