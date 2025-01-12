#!/bin/bash

# Build variables
REPO_DIR=${REPO_DIR:-/project}
BUILD_DIR=${BUILD_DIR:-/build}
CODEQL_BIN=${CODEQL_BIN:-/opt/codeql/codeql}
INFER_BIN=${INFER_BIN:-/opt/infer-linux64-v1.1.0/bin/infer}
SETUP_COMMANDS=${SETUP_COMMANDS:-""}
BUILD_COMMANDS=${BUILD_COMMANDS:-""}
TOOL_BUILD_COMMAND=${TOOL_BUILD_COMMAND:-""}

cd ${REPO_DIR}
# Execute setup commands
IFS=';' read -ra COMMANDS <<< "${SETUP_COMMANDS}"
for COMMAND in "${COMMANDS[@]}"; do
    echo "Running: ${COMMAND}"
    eval "${COMMAND}"
done

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
# Execute build commands
IFS=';' read -ra COMMANDS <<< "${BUILD_COMMANDS}"
for COMMAND in "${COMMANDS[@]}"; do
    echo "Running: ${COMMAND}"
    eval "${COMMAND}"
done

# ${CODEQL_BIN} database create codeql-db --language cpp --command "${TOOL_BUILD_COMMAND}" --source-root ${REPO_DIR}
# ${CODEQL_BIN} database analyze codeql-db --format sarif-latest --threads=4 --output results.sarif

${INFER_BIN} run -- ${TOOL_BUILD_COMMAND}