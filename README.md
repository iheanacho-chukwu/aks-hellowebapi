#  Pushing the Image to Azure Container Registry (ACR)

## Create an ACR (if you don’t have one yet):
```bash
az login
az acr create --resource-group <your-resource-group> --name <your-acr-name> --sku Basic
```
## Tag the Docker Image for ACR:
```bash
docker tag webapi <your-acr-name>.azurecr.io/webapi:v1
```
## Push the Image to ACR:
```bash
docker push <your-acr-name>.azurecr.io/webapi:v1
```

# Deploying the Application to AKS

- Create a Deployment and Service YAML (webapi-deployment.yaml)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapi
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapi
  template:
    metadata:
      labels:
        app: webapi
    spec:
      containers:
      - name: webapi
        image: <your-acr-name>.azurecr.io/webapi:v1
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: webapi-service
spec:
  selector:
    app: webapi
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```
- Authorize AKS to Pull from ACR:
```bash
az aks update -n <your-cluster-name> -g <your-resource-group> --attach-acr <your-acr-name>
```
- Apply the Configuration:
```bash
kubectl apply -f webapi-deployment.yaml
```

# Test the Application
The LoadBalancer in AKS makes your app accessible from the internet. Follow these steps to access it:

Get the External IP:
```bash
kubectl get svc
```

visit http://<EXTERNAL-IP>/ in your browser. You should see "HellowebAPI containerized application: Hello from this side of life!".
