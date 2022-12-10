#!/bin/sh

# Decrypt the file
# --batch to prevent interactive command
# --yes to assume "yes" for questions

# iOS
gpg --quiet --batch --yes --decrypt --passphrase="$LARGE_SECRET_PASSPHRASE" \
  --output ios/Runner/GoogleService-Info.plist .github/workflows/secrets/GoogleService-Info-Staging.plist.gpg
