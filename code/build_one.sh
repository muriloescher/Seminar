#!/bin/bash
set -e

# Check if the project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME=$1
CONFIG_FILE="projects.yml"

# Check if the project exists in the YAML file
PROJECT_EXISTS=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\")" $CONFIG_FILE)
if [ -z "$PROJECT_EXISTS" ]; then
    echo "Project '$PROJECT_NAME' not found in $CONFIG_FILE."
    exit 1
fi

# Extract project details
REPO_URL=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .repo_url" $CONFIG_FILE)
COMMIT_HASH=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .commit_hash" $CONFIG_FILE)
SETUP_COMMANDS=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .setup_commands[]" $CONFIG_FILE | tr '\n' ';')
BUILD_COMMANDS=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .build_commands[]" $CONFIG_FILE | tr '\n' ';')
TOOL_BUILD_COMMAND=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .tool_build_command" $CONFIG_FILE)
DEPENDENCIES=$(yq e ".projects[] | select(.name == \"$PROJECT_NAME\") | .dependencies" $CONFIG_FILE)

# Build the Docker image for the specified project
echo "Building image for project: $PROJECT_NAME"
docker build --build-arg REPO_URL=${REPO_URL} \
             --build-arg COMMIT_HASH=${COMMIT_HASH} \
             --build-arg SETUP_COMMANDS="${SETUP_COMMANDS}" \
             --build-arg BUILD_COMMANDS="${BUILD_COMMANDS}" \
             --build-arg TOOL_BUILD_COMMAND="${TOOL_BUILD_COMMAND}" \
             --build-arg DEPENDENCIES="${DEPENDENCIES}" \
             -t ${PROJECT_NAME}:latest \
             -f base.Dockerfile .
