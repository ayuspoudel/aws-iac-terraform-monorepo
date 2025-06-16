#!/bin/bash
set -e

# Config
GH_OWNER="ayuspoudel"              # Your GitHub username or org
GH_PAT_TOKEN="${GH_PAT_TOKEN}"     # Passed from workflow
RUNNER_LABELS="aws-ec2"
GH_RUNNER_VERSION="2.315.0"

# Create actions-runner directory
mkdir -p /opt/actions-runner
cd /opt/actions-runner

# Install required packages
yum install -y curl jq git

# Download runner
curl -o actions-runner.tar.gz -L \
  "https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz"
tar xzf actions-runner.tar.gz

# Fetch org-wide registration token
REG_TOKEN=$(curl -s -X POST \
  -H "Authorization: token ${GH_PAT_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/${GH_OWNER}/actions/runners/registration-token" | jq -r .token)

# Configure runner
./config.sh \
  --url "https://github.com/${GH_OWNER}" \
  --token "${REG_TOKEN}" \
  --unattended \
  --name "$(hostname)" \
  --labels "${RUNNER_LABELS}"

# Start runner
./run.sh
