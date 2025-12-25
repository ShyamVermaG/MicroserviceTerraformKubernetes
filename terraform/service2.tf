apiVersion: apps/v1
kind: Deployment
metadata:
  name: service2
  namespace: microservices
  labels:
    app: service2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service2
  template:
    metadata:
      labels:
        app: service2
    spec:
      containers:
        - name: service2
          image: ${SERVICE2_IMAGE}
          imagePullPolicy: Always

          ports:
            - containerPort: 8081

          env:
            - name: DB_HOST
              value: postgres
            - name: DB_PORT
              value: "5432"
            - name: DB_NAME
              value: testdb
            - name: DB_USER
              value: postgres
            - name: DB_PASSWORD
              value: postgres

          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"

          startupProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8081
            failureThreshold: 30
            periodSeconds: 5

          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8081
            initialDelaySeconds: 40
            periodSeconds: 10

          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8081
            initialDelaySeconds: 30
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: service2
  namespace: microservices
spec:
  selector:
    app: service2
  ports:
    - port: 8081
      targetPort: 8081
  type: ClusterIP
