#!/bin/bash

# Can not read file, not enough memory
truncate -s 10G test_file.txt;
status_code=$(curl --write-out %{http_code} http://localhost:8080/file/read -v);
echo $status_code
if [[ "$status_code" != *"503"* ]]; then
  echo "Test case: not enough memory is FAILED"
else
  echo "Test case: not enough memory is PASSED"
fi
echo ""

# File can be read but out of time
truncate -s 1G test_file.txt;
status_code=$(curl --write-out %{http_code} http://localhost:8080/file/read -v);
echo $status_code
if [[ "$status_code" != *"503"* ]]; then
  echo "Test case: file reading out of time is FAILED"
else
  echo "Test case: file reading out of time is PASSED"
fi
echo ""

# Read file successfully
truncate -s 1M test_file.txt;
status_code=$(curl --write-out %{http_code} http://localhost:8080/file/read -v);
echo $status_code
if [[ "$status_code" != *"200"* ]]; then
  echo "Test case: file read successfully is FAILED"
else
  echo "Test case: file read successfully is PASSED"
fi