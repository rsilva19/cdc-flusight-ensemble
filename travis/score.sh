#!/usr/bin/env bash

# Script for generating scores
set -e

yarn
echo "This is a trigger to generate scores."
# Generate ./scores/scores.csv
yarn run generate-scores
# Generate model id mappings
yarn run generate-id-mappings
# Fix model metadata formatting
yarn run format-metadata
echo "> Pushing formatted metadata, scores and model-id-mapping csvs"
git add ./scores/scores.csv
git add ./csv-error.log
git add ./csv-blacklist.yaml
git add ./scores/scores.csv
git add ./model-forecasts/component-models/complete-modelids.csv
git add ./model-forecasts/component-models/model-id-map.csv
git add ./model-forecasts/*/*/metadata.txt
git diff-index --quiet HEAD || git commit -m "[TRAVIS] Autogenerated files from travis"

# Pull if origin has new files
git pull $SSH_REPO master --no-edit
git push $SSH_REPO HEAD:master
