#!/bin/bash

# Vault Configuration
VAULT_ADDR="http://10.100.1.200:8500" # Vault server address
ROLE_NAME="terraform-role"                # AppRole name
APPROLE_PATH="auth/approle/role/$ROLE_NAME/secret-id"
SECRET_FILE="/tmp/vault_secret_id.json"   # Temporary file for secret_id data

# Function: Fetch a new secret_id
fetch_secret_id() {
  echo "Fetching secret_id from Vault..."

  # Send a request to Vault to get the secret_id
  RESPONSE=$(curl -s --request POST \
    --data '{}' \
    "$VAULT_ADDR/v1/$APPROLE_PATH")

  # Check if the response contains a valid secret_id
  if [[ $(echo "$RESPONSE" | jq -r '.data.secret_id') == null ]]; then
    echo "Error: Failed to fetch secret_id from Vault."
    echo "Response: $RESPONSE"
    exit 1
  fi

  # Save secret_id and metadata to a file
  echo "$RESPONSE" > "$SECRET_FILE"
  echo "Secret ID has been fetched and saved to $SECRET_FILE."
}

# Function: Retrieve secret_id from the file
get_secret_id() {
  jq -r '.data.secret_id' "$SECRET_FILE"
}

# Main logic
if [[ -f "$SECRET_FILE" ]]; then
  echo "Secret ID already exists: $(get_secret_id)"
else
  fetch_secret_id
fi

# Export secret_id as an environment variable
SECRET_ID=$(get_secret_id)
export TF_VAR_secret_id="$SECRET_ID"
echo "Secret ID has been set as an environment variable."
