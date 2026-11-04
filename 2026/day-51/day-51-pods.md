-----------------------------------------------------------------
Sample k8s manifest:

apiVersion: v1          # Which API version to use
kind: Pod               # What type of resource
metadata:               # Name, labels, namespace
  name: my-pod
  labels:
    app: my-app
spec:                   # The actual specification (what you want)
  containers:
  - name: my-container
    image: nginx:latest
    ports:
    - containerPort: 80


-----------------------------------------------------------------
Task 1 :  

1. 
#    creating first pod:
   docker has container
   k8s has pod

vi nginx-pod.yml

apiVersion: v1
kind: Pod

metadata:
  name: nginx-pod
  labels:
    app: nginx

spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80

----
kubectl apply -f nginx-pod.yml
kubectl get pods
kubectl get pods -o wide # pod ip, nodename, age
kubectl decribe pod nginx-pod # metadata, container, images
kubectl logs nginx-pod 

# entering pod
kubectl exec -it nginx-pod -- /bin/bash
or
kubectl exec -it nginx-pod -- /bin/sh

# test nginx
curl localhost:80

-----------------------------------------------------------------
Task 2 : creating BusyBox Pod

vi busybox-pod.yaml

apiVersion: v1
kind: Pod

metadata:
    name: busybox-pod
    labels:
        app: busybox
        environment: dev

spec:
    containers:
    - name: busybox
      image: busybox:latest
      command:
        - sh
        - -c
        - echo hello from BusyBox && sleep 3600 # Without a long-running process the container exits immediately, causing Kubernetes to restart it repeatedly and potentially enter CrashLoopBackOff.

-----
kubectl apply -f busybox-pod.yml
kubectl get pods
kubectl logs busybox-pod

-----------------------------------------------------------------

Task 3: Imperative vs Declarative

declarative approach:
- we write the desired state in YAML 
  
kind: Pod
metadata:
    name: nginx-pod

kubectl apply -f nginx-pod.yml

imperative approach:
- kubectl run redis-pod --image=redis:latest
- kubectl get pods

# extracting generated YAML:
kubectl get pod redis-pod -o yaml

# generating YAML using dry run:
kubectl run test-pod --image=nginx --dry-run=client -o yaml
this wont create a file , it will just show the contents of the file

kubectl run test-pod --image=nginx --dry-run=client -o yaml > test-pod.yml 
this will create the POD

# essential fields:
apiVersion
kind
metadata
spec
containers
image

-----------------------------------------------------------------
Task 4: 

1. client side validation:
   kubectl apply -f nginx-pod.yaml --dry-run=client
   checks syntax and structure on local machine

2. server side validation:
   kubectl apply -f nginx-pod.yml --dry-run=server
   validates via kubernetes API server 

   k8s gives:
   spec.containers[0].image: Required value
   if the image is missing

-----------------------------------------------------------------
Task 5

1. Labels = tags
   kubectl get pods --show-labels
   kubectl get pods -l app=nginx # finding nginx pods
   kubectl get pods -l environment=dev # finding dev pods

2. adding label dynamically
   kubectl label pod nginx-pod environment=production
   kubectl get pods --show-labels

3. removing label:
   kubectl label pod nginx-pod environment

4. creating pod with 3 labels:
apiVersion: v1
kind: Pod

metadata:
  name: alpine-pod
  labels:
    app: alpine
    ennvironment: test
    team: devops

spec:
  containers:
  - name: alpine
    image: alpine:latest
    command: 
      - sh
      - -c
      - sleep 3600
      
kubectl apply -f alpine-pod.yml

filtering:
    kubectl get pods -l app=alpine
    kubectl get pods -l environment=test
    kubectl get pods -l team=devops

    kubectl get pods -l app=alpine,environment=test

    kubectl get pods --show-labels    

-----------------------------------------------------------------
Task 6: clean up

1. deleting all pods:
   kubectl delete pod nginx-pod
   kubectl delete pod busybox-pod
   kubectl delete pod redis-pod
   kubectl delete pod alpine-pod

   kubectl delete -f nginx-pod.yml

   all these were standalone pods. If deleted, cant be restored.
   in production, if Pod crashes, Deployement notices and creates new POD automatically
   deployments are used to provide self-healing, scaling and automatic pod recreation

   in real-world deployments, applications are not directly ran on PODS

2. Manifest:
   - Yaml/Json file which has desired config of POD
   - pod name
   - container used
   - ports
   - env variables
   - volume/restart policy
   - instruction file for k8s to create a POD







