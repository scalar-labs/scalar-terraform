#!/bin/sh -l

tag=${1##*/}
echo "Generate release notes for tag ${tag}."

gren release -d -t ${tag}
