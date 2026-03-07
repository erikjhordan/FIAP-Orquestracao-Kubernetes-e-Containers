#!/bin/bash
set -euo pipefail

REGION="us-east-1"
ACCOUNT_ID="$(aws sts get-caller-identity | jq -r .Account)"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
