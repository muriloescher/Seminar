ARROW=${SRC}/arrow/cpp
CODEQL=${SRC}/codeql/codeql

mkdir ${WORK}
cd ${WORK}
cmake ${ARROW}

${CODEQL} database create codeql-db --language cpp --command "cmake --build ." --source-root ${ARROW}
${CODEQL} database analyze codeql-db --format sarif-latest --output results.sarif