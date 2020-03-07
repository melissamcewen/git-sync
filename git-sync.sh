#!/bin/sh

set -e

SOURCE_REPO=$1
SOURCE_BRANCH=$2
GLITCH_TOKEN=$5
DESTINATION_REPO="https://${GLITCH_TOKEN}@api.glitch.com/git/witty-silk-thief"
DESTINATION_BRANCH=$4

if ! echo $SOURCE_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY" ]]
  then
    SOURCE_REPO="git@github.com:${SOURCE_REPO}.git"
    GIT_SSH_COMMAND="ssh -v"
  else
    SOURCE_REPO="https://github.com/${SOURCE_REPO}.git"
  fi
fi
if ! echo $DESTINATION_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY" ]]
  then
    DESTINATION_REPO="git@github.com:${DESTINATION_REPO}.git"
    GIT_SSH_COMMAND="ssh -v"
  else
    DESTINATION_REPO="https://github.com/${DESTINATION_REPO}.git"
  fi
fi

echo "SOURCE=$SOURCE_REPO:$SOURCE_BRANCH"
echo "DESTINATION=$DESTINATION_REPO:$DESTINATION_BRANCH"

git clone "$SOURCE_REPO" --origin source && cd `basename "$SOURCE_REPO" .git`
git remote add destination "$DESTINATION_REPO"
git push destination "${SOURCE_BRANCH}:${DESTINATION_BRANCH}" -f
