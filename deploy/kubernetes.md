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

### Admin Password

The API assumes that a password will be set through an environment variable. The `api-server` deployment sets up a pod that will read this value from a secret called `serv-admin-password` with a `password` field. You can set it through something like

```bash
kubectl create secret generic serv-admin-password --from-literal=password=foobar
```

where `foobar` is your password.

### Erlang Cookie

In order for the different Elixir applications to communicate, a cookie has to be configured that they all share. Since you can provide this as a flag at the time that the application is started, you should use a secret to configure and manage this value.  Something like this should do:

```bash
kubectl create secret generic app-config --from-literal=erlang-cookie=DCRVBIZHJWHNZXYVSFPG
```

where the value for `erlang-cookie=` should be whatever you want to make it. The value does not matter, but it should be a nice random string like the example above to prevent unexpected processes from being able to connect.

## Services

Launching the services are relatively easy. There are existing config files that can be used to create the two controllers and corresponding deployments.

```bash
# Allow file server nodes to find the API server
kubectl create -f deploy/epmd-api-server.yml
# Expose the API server with an external IP address
kubectl create -f deploy/expose-api-server.yml
# Expose the file server with an external IP address
kubectl create -f deploy/expose-file-server.yml
# Start a base file server deployment
kubectl create -f deploy/file-server-deployment.yml
# Start a base API server deployment
kubectl create -f deploy/api-server-deployment.yml
```

Once everything settles, the services should be good to go.
