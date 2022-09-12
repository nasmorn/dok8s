# DOK8S

Contains the necessary code to deploy an app to a Digital Ocean Kubernetes cluster via Github Actions

## Setup Commands

Don't forget that Github Actions will need the `RAILS_MASTER_KEY` and a `DIGITALOCEAN_ACCESS_TOKEN` as secrets

- `rails ci:setup` - Copies Dockerfile and ci pipeline to project
- `rails k8s:setup` - Creates kubernetes yaml files
- `rails k8s:init` - Creates the secret for RAILS_MASTER_KEY on kubernetes

## Dev Helpers

- `rails db:sync` - Overwrites the local dev DB with the production DB


# Imagor

Initial deploy

    kubectl create secret generic imagor \
      --from-literal=IMAGOR_SECRET=THE_ACTUAL_SECRET

## Redeploy

Edit the file to e.g upgrade the image


    kubectl apply -f lib/dok8s/k8s/imagor.yml

