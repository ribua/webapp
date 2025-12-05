# OpenShift Web Application

A sample Node.js web application containerized using Red Hat UBI 9 and configured for deployment on OpenShift.

## Building the Container Image

### Option 1: Build locally and push to OpenShift registry

```bash
# Login to OpenShift
oc login

# Create a new project (if needed)
oc new-project your-namespace

# Build and push the image
podman build -t webapp:latest .
podman tag webapp:latest default-route-openshift-image-registry.apps.your-cluster.com/your-namespace/webapp:latest
podman push default-route-openshift-image-registry.apps.your-cluster.com/your-namespace/webapp:latest
```

### Option 2: Use OpenShift BuildConfig (Source-to-Image)

```bash
# Create a BuildConfig from the Dockerfile
oc new-build --name=webapp --binary --strategy=docker

# Start a build from the current directory
oc start-build webapp --from-dir=. --follow

# The image will be available at: image-registry.openshift-image-registry.svc:5000/your-namespace/webapp:latest
```

## Deploying to OpenShift

1. Update the image reference in `deployment.yaml` with your namespace:
   ```bash
   sed -i 's/your-namespace/my-project/g' deployment.yaml
   ```

2. Apply the deployment:
   ```bash
   oc apply -f deployment.yaml
   ```

3. Get the route URL:
   ```bash
   oc get route webapp
   ```

## Features

- **RHEL UBI 9 Base Image**: Uses Red Hat's Universal Base Image for enterprise support
- **Non-root User**: Runs as user 1001 for security
- **Health Checks**: Includes liveness and readiness probes
- **Resource Limits**: Configured with appropriate CPU and memory limits
- **OpenShift Route**: TLS-enabled route with edge termination
- **Security Context**: Follows OpenShift security best practices

## Testing Locally

```bash
# Build the image
podman build -t webapp:latest .

# Run the container
podman run -p 8080:8080 webapp:latest

# Test the endpoints
curl http://localhost:8080/
curl http://localhost:8080/health
```

## Endpoints

- `GET /` - Main application endpoint
- `GET /health` - Health check endpoint
