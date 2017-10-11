# Deploying to Kubernetes

Serv is built to be run on Kubernetes, hosted on GKE (Google Container Engine).

All of these commands assuming that `kubectl` is already configured to point to your Kubernetes cluster.

## Secrets

### PostGres

Since GCP provides a hosted PostGres service, we can connect to that instead of hosting something ourselves. All that needs to be configured is some secrets so that the authentication is done correctly.  The `deployment` configurations are already set up to add the "sidecar" container to the pod that acts a proxy to the PostGres service.

Follow the directions [here](https://cloud.google.com/sql/docs/postgres/connect-container-engine) to see how to set up a GKE pod to talk to the hosted PostGres service.

**Note:** This is the hardest part. If you can get through this, you're almost good to go. I've done the rest of the "hard part" through the pre-made configuration files checked into the repo.

#### Migration

Currently a PITA. Docs TBD.

### Password

The Admin API assumes that a password will be set through a Kubernetes secret called `serv-admin-password` with a `password` field. You can set it through something like

```bash
kubectl create secret generic serv-admin-password --from-literal=password=foobar
```

where `foobar` is your password.

## Services

Launching the services are relatively easy. There are existing config files that can be used to create the two controllers and corresponding deployments.

```bash
kubectl create -f deploy/file-server-controller.yml
kubectl create -f deploy/file-server-deployment.yml
kubectl create -f deploy/api-server-controller.yml
kubectl create -f deploy/api-server-deployment.yml
```

Once everything settles, the services should be good to go.
