#!/usr/bin/env bash

curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=httpbin4' \
  --data 'uris=//httpbin4' \
  --data 'methods=GET,POST' \
  --data 'upstream_url=http://httpbin.org'