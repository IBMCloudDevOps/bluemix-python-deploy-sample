# Bluemix Python Deploy Sample

The deployment repo that accompanies the recipe: [Separating Continuous Integration from Continuous Deployment using GitHub and Travis CI](https://developer.ibm.com/recipes/tutorials/separating-continuous-integration-from-continuous-deployment-using-github-and-travis-ci/)

## Properties
Deploys an application from Travis CI to Bluemix
Set the following variables in travis to use:
  - ```GITHUB_OAUTH_TOKEN``` - Your GitHub OAuth token
  - ```APP_REPO_OWNER``` - The owner of the app repo to deploy
  - ```APP_REPO_NAME``` - The name of the app repo to deploy
  - ```BLUEMIX_USER``` - The Bluemix user to deploy as
  - ```BLUEMIX_PASS``` - The password for that Bluemix user
  - ```BLUEMIX_ORGANIZATION``` - The Bluemix organization to deploy to
  - ```BLUEMIX_SPACE``` - The Bluemix space to deploy to
