#  Microservices with PostgreSQL and Kubernetes

This project consists of two Java 17 microservices:
- **Service 1**: REST API service that calls Service 2
- **Service 2**: Database service that queries PostgreSQL

## Project Structure

```
.
├── service1/              # REST API Service
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── service2/              # Database Service
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
└── k8s/                   # Kubernetes configurations
    ├── postgres-deployment.yaml
    ├── service1-deployment.yaml
    └── service2-deployment.yaml
```

## Prerequisites

- Java 17
- Maven 3.6+
- Docker Desktop for Windows with Kubernetes enabled
- kubectl CLI tool

## Local Development

### Build Services

```bash
# Build Service 1
cd service1
mvn clean package

# Build Service 2
cd ../service2
mvn clean package
```

### Run Locally

1. Start PostgreSQL (using Docker):
```bash
docker run -d --name postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=testdb -p 5432:5432 postgres:15-alpine
```

2. Run Service 2:
```bash
cd service2
mvn spring-boot:run
```

3. Run Service 1 (in another terminal):
```bash
cd service1
mvn spring-boot:run
```

## Kubernetes Deployment on Windows Docker Desktop

### Step 1: Enable Kubernetes in Docker Desktop

1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"
5. Wait for Kubernetes to start (green indicator)

### Step 2: Verify Kubernetes is Running

```powershell
kubectl cluster-info
kubectl get nodes
```

### Step 3: Build Docker Images

Since we're using `imagePullPolicy: Never`, we need to build images locally:

```powershell
# Build Service 1 image
cd service1
docker build -t service1:latest .

# Build Service 2 image
cd ../service2
docker build -t service2:latest .
```

### Step 4: Deploy to Kubernetes

Deploy components in order:

```powershell
# 1. Deploy PostgreSQL
kubectl apply -f k8s/postgres-deployment.yaml

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s

# 2. Deploy Service 2 (Database Service)
kubectl apply -f k8s/service2-deployment.yaml

# Wait for Service 2 to be ready
kubectl wait --for=condition=ready pod -l app=service2 --timeout=120s

# 3. Deploy Service 1 (REST API Service)
kubectl apply -f k8s/service1-deployment.yaml

# Wait for Service 1 to be ready
kubectl wait --for=condition=ready pod -l app=service1 --timeout=120s
```

### Step 5: Verify Deployment

```powershell
# Check all pods
kubectl get pods

# Check all services
kubectl get services

# Check logs
kubectl logs -l app=service1
kubectl logs -l app=service2
kubectl logs -l app=postgres
```

### Step 6: Access Service 1

Get the service URL:

```powershell
# For LoadBalancer service (may show <pending> on Docker Desktop)
kubectl get service service1

# Use port forwarding to access locally
kubectl port-forward service/service1 8080:8080
```

Then access:
- Health check: http://localhost:8080/api/data/health
- Get data by ID: http://localhost:8080/api/data/1
- Get all data: http://localhost:8080/api/data/all

## API Endpoints

### Service 1 (REST API)

- `GET /api/data/health` - Health check
- `GET /api/data/{id}` - Get data by ID (calls Service 2)
- `GET /api/data/all` - Get all data (calls Service 2)

### Service 2 (Database Service)

- `GET /api/db/health` - Health check
- `GET /api/db/data/{id}` - Get data by ID from database
- `GET /api/db/data/all` - Get all data from database

## Troubleshooting

### Check Pod Status

```powershell
kubectl describe pod <pod-name>
```

### View Pod Logs

```powershell
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # Follow logs
```

### Restart a Deployment

```powershell
kubectl rollout restart deployment/service1
kubectl rollout restart deployment/service2
```

### Delete Everything

```powershell
kubectl delete -f k8s/
```

## Notes

- PostgreSQL data is persisted using a PersistentVolumeClaim
- Services use ClusterIP for internal communication
- Service 1 uses LoadBalancer type for external access (use port-forward on Docker Desktop)
- Images are built locally and use `imagePullPolicy: Never`
- Health checks are configured for both services
 
