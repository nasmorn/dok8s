# DOK8S

Contains the necessary code to deploy an app to a Digital Ocean Kubernetes cluster via Github Actions

## Setup Commands

- `rails ci:setup` - Copies Dockerfile and ci pipeline to project
- `rails k8s:setup` - Creates kubernetes yaml files
- `rails k8s:init` - Creates the secret for RAILS_MASTER_KEY on kubernetes

## Dev Helpers

- `rails db:sync` - Overwrites the local dev DB with the production DB
