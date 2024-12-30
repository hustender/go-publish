#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <github_url> <commit_message> <version>"
    exit 1
fi

GITHUB_URL=$1
COMMIT_MESSAGE=$2
VERSION=$3

echo "The following files are available to be committed:"
git status --short

read -p "Do you want to stage all changes? (y/n): " STAGE_ALL

if [ "$STAGE_ALL" == "y" ]; then
    git add .
else
    echo "No files were staged. Please stage files manually if needed."
    echo "You can use 'git add <file>' to add specific files."
    exit 1
fi

git commit -m "${COMMIT_MESSAGE}@${VERSION}"

git push origin master

git tag "${VERSION}"

git push origin "${VERSION}"

GOPROXY=proxy.golang.org go list -m "${GITHUB_URL}"@"${VERSION}"

if [ $? -eq 0 ]; then
    echo "Version ${VERSION} tagged and validated successfully."
else
    echo "An error occurred during the validation of version ${VERSION}."
fi
