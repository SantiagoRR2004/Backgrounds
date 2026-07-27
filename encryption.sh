#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ENCRYPTED_DIR="${SCRIPT_DIR}/.backgrounds.enc"
NORMAL_DIR="${SCRIPT_DIR}/backgrounds"

# Ensure both directories exist
mkdir -p "${ENCRYPTED_DIR}"
mkdir -p "${NORMAL_DIR}"

GPG_OPTIONS=(
    --batch
    --yes
    --quiet
    --pinentry-mode loopback
    --passphrase "images"
)

# Decrypt the files
for file in "${ENCRYPTED_DIR}"/*; do
    if [[ -f "$file" ]]; then
        echo "$(basename "$file")"
        gpg "${GPG_OPTIONS[@]}" --decrypt "$file" > "${NORMAL_DIR}/$(basename "$file" .gpg)"
    fi
done

# Encrypt the files
for file in "${NORMAL_DIR}"/*; do
    if [[ -f "$file" ]]; then
        echo "$(basename "$file")"
        gpg "${GPG_OPTIONS[@]}" --symmetric --cipher-algo AES256 "$file"
        mv "${file}.gpg" "${ENCRYPTED_DIR}/"
    fi
done
