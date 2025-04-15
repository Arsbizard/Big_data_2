#!/bin/bash
spark-submit --master yarn --deploy-mode client /app/query.py "$1"