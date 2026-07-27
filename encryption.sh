#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ENCRYPTED_DIR="${SCRIPT_DIR}/.backgrounds.enc"
NORMAL_DIR="${SCRIPT_DIR}/backgrounds"

# Ensure both directories exist
mkdir -p "${ENCRYPTED_DIR}"
mkdir -p "${NORMAL_DIR}"

KEY=$(printf "images" | sha256sum | cut -d' ' -f1)
SSL_OPTIONS=(
    -aes-256-ctr
    -K "$KEY"
)

# Decrypt the files
for file in "${ENCRYPTED_DIR}"/*; do
    if [[ -f "$file" ]]; then
        BASE_NAME=$(basename "$file" .enc)
        IV=$(printf "%s" "$BASE_NAME" | sha256sum | cut -c1-32)
        echo $BASE_NAME
        openssl enc -d "${SSL_OPTIONS[@]}" -iv "$IV" -in "$file" -out "${NORMAL_DIR}/${BASE_NAME}"
    fi
done

# Encrypt the files
for file in "${NORMAL_DIR}"/*; do
    if [[ -f "$file" ]]; then
        BASE_NAME=$(basename "$file")
        IV=$(printf "%s" "$BASE_NAME" | sha256sum | cut -c1-32)
        echo $BASE_NAME
        openssl enc -e "${SSL_OPTIONS[@]}" -iv "$IV" -in "$file" -out "${ENCRYPTED_DIR}/${BASE_NAME}.enc"
    fi
done
