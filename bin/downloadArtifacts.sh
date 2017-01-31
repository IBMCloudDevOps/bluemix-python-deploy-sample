#!/bin/bash

GH_BASE_URL=$OCTOKIT_API_ENDPOINT
# Check if GHE url is set, if not fall back to public GH
if [ -z $OCTOKIT_API_ENDPOINT ]; then
  #If we are running in travis, try using OCTOKIT_API_ENDPOINT instead
  GH_BASE_URL="https://api.github.com/"
  echo "No GitHub url specified, using: $GH_BASE_URL"
fi

#Get the release assets
RELEASE_URL="$GH_BASE_URL"repos"/$APP_REPO_OWNER/$APP_REPO_NAME/releases/latest"

# Get the release data
echo "curling $RELEASE_URL"

# If you are getting rate limited or using GHE, add a GH_token to authenticate
if [ -n "$GH_TOKEN" ]; then
  echo "Using GitHub token"
  HEADER="Authorization: Token $GH_TOKEN"
  RELEASE=$(curl -H "$HEADER" $RELEASE_URL)
else
  echo "Not using GitHub token"
  RELEASE=$(curl $RELEASE_URL)
fi

# Parse the release info
ASSET_LIST=$(echo $RELEASE | jq ".assets")
ASSET_LIST_LENGTH=$(echo $ASSET_LIST | jq ". | length")

# If we got a message (error) display it here
echo $RELEASE | jq ".message"

# Put all assets in the deploy directory
mkdir deploy
cd deploy

COUNTER=0
# For each asset in the list
while [ "$COUNTER" -le "$ASSET_LIST_LENGTH" ]; do

  echo The counter is $COUNTER

  # Get the asset name and URL
  ASSET_NAME=$(echo $ASSET_LIST | jq ".[$COUNTER] | .name" | sed s/\'//g | sed s/\"//g)
  ASSET_URL=$(echo $ASSET_LIST | jq ".[$COUNTER] | .url" | sed s/\'//g | sed s/\"//g)

  let COUNTER=COUNTER+1

  # If the URL is not null literal
  if [ "$ASSET_URL" != "null" ]; then

    echo "curl -L $ASSET_URL > $ASSET_NAME"

    # Support for GHE
    if [ -n "$GH_TOKEN" ]; then
      echo "Using GitHub token"
      HEADER="Authorization: Token $GH_TOKEN"
      # Get the artifact
      curl -H "$HEADER" -H "Accept: application/octet-stream" -L $ASSET_URL > $ASSET_NAME
    else
      # Get the artifact
      curl -H "Accept: application/octet-stream" -L $ASSET_URL > $ASSET_NAME
    fi

    # Expecting all assets to be tarballs, modify as needed
    tar -xvzf $ASSET_NAME

    # Clean up archive directory
    rm $ASSET_NAME
  fi
done

#debug
echo "pwd"
pwd
echo "ls -halt"
ls -halt
