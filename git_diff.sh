#!/bin/bash
npm install tsc -g
affected=$(git diff --dirstat origin/staging | sed 's/^[ 0-9.]*% //g')

for dir in $affected
do
    echo ~/$dir
    # ls -la
done