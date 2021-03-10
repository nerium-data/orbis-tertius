#!/bin/bash

set -e

# run orbis to generate Markdown files
orbis

# build static HTML from Markdown with Hugo
hugo -s /app/dictionary -d /public --cleanDestinationDir --minify

mkdir -p /public/markdown
cp /app/dictionary/content/*.md /public/markdown/

exec "$@"
