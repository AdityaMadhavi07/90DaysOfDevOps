Why Services?
Every Pod gets its own IP address. But there are two problems:

Pod IPs are not stable — when a Pod restarts or gets replaced, it gets a new IP
A Deployment runs multiple Pods — which IP do you connect to?
A Service solves both problems. It provides:

A stable IP and DNS name that never changes
Load balancing across all Pods that match its selector

when pod restarts, the IPs gets changed
Service provides a stable endpoint

Client
   ↓
Service
   ↓
Pod1
Pod2
Pod3

------------------------------------------------------------------
Task 1:

vi app-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app

spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
  
1. kubectl apply -f app-deployment.yml
   kubectl get pods -o wide

   IPs:
   10.244.0.15
   10.244.0.16
   10.244.0.17

------------------------------------------------------------------
Task 2: Cluster Ip = internal service

1. vi clusterip-service.yml

apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip

spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
  
2. kubectl apply -f clusterip-service.yml
   kubectl get svc

3. testing service:
   kubectl run test-client --image=busybox:latest --rm -it --restart=Never --sh
        wget -q0- http://web-app-clusterip

    kubectl get endpoints web-app-clusterip
    # shows service routing to which endpoints

------------------------------------------------------------------
Task 3: Service DNS

1. every service automatically gets DNS
   service.namespace.svc.cluster.local

2. kubectl run dns-test --image=busybox:latest --rm -it --restart=Never -- sh
   wget -qO- http://web-app-clusterip
   wget -qO- http://web-app-clusterip.default.svc.cluster.local
   nslookup web-app-clusterip
   
   Ip matches with- kubectl get svc

------------------------------------------------------------------
Task 4: NodePort Service

1. NodePort allows access from outside cluster
   
Browser
   ↓
NodeIP:30080
   ↓
Service
   ↓
Pods

vi nodeport-service.yml

apiVersion: v1
kind: Service

metadata:
  name: web-app-nodeport

spec:
  type: NodePort
  selector:
    app: web-app
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080

kubectl apply -f nodeport-service.yml
kubectl get svc

kubectl get nodes -o wide

note: nginx page visible through NodePort
kubectl get endpoints web-app-nodeport

------------------------------------------------------------------
Task 5: LoadBalancer Service

1. internet--> load balancer --> service --> pods
   kubectl apply -g loadbalancer-service.yml
   kubectl get svc

vi loadbalancer-service.yml

apiVersion: v1
kind: Service

metadata:
  name: web-app-loadbalancer

spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
    - port: 80
      targetPort: 80
      

kubectl apply -f loadbalancer-service.yaml
kubectl get svc # pending because we are running local cluster without cloud, no load-balancer exists
no cloud provicder to create a real-load balancer

load balancer service automatically gets both- ClusterIp and NodePort

------------------------------------------------------------------
Task 6: Comparing service types

1. clusterIP - inside cluster only
   to connect frontend- backend
   backend to database
2. load balancer - public internet
   for prod appliances
3. load balancer contains node port which contains cluster IP
   
4. kubectl describe svc web-app-loadbalancer

------------------------------------------------------------------
Task 7: cleaning up

1. kubectl delet -f app-deployment.yml
   kubectl delete -f clusterip-service.yml
   kubectl delete -f nodeport-service.yml
   kubectl delete -f loadbalancer-service.yml

2. kubectl get svc
   kubectl get pods
   kubectl get svc -o wide
   kubectl get endpoints
   kubectl get pods -o wide


-------------------------------------------------------------------

Note: 
Pod IPs change after restart. Deployment has multiple pods so which IP must client use?
service provides stable endpoint, DNS name and load balancing between pods

A. cluster Ip service
    - default service type
    - accessible only inside k8s cluster
    - eg when frontend pod wants to call backend pod, it can call via name
    - works inside cluster only
    - cannot access from browser on yr laptop
    
B. NodePort service
    - exposes app outside the cluster using :
        <NodeIP>:<NodePort>
    - used for testing
    - Exposes a service outside the cluster using NodeIP and a port in the range 30000–32767.

C. Load Balancer Service:
    - production-friendly external access
    - cloud auto-creates a LB
    - internet -> cloud LB -> Nodes -> Pods
    - aws auto creates ELB/ALB



