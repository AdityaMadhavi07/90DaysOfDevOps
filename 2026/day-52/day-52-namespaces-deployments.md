Task 1: namespaces

Namespace: logical isolation mechanism used to organize and separate resources within the same cluster
Pod: smallest deployable unit in k8s that runs 1+ containers sharing network and storage
kind: tool that runs local k8s clusters using docker containers mainly for deployment and testing

1. kubectl get namespaces
   kubectl get ns

2. kubectl get pods -n kube-system #pods running in kube-system namespace
3. kubectl get pods -n kube-system --no-headers | wc -l
    # count of total pods:
    kubectl get pods -A --no-headers | wc -l


-------------------------------------------------------------------------------
Task 2: custom namespaces

1. kubectl create namespace dev
   kubectl create namespace staging
   kubectl get ns

2. creating namespace with YAML:
  vi namespace.yml

apiVersion: v1
kind: Namespace

metadata:
  name: production

kubectl apply -f namespace.yml

3. running pods in diff env:
   kubectl run nginx-dev --image=nginx:latest -n dev
   Read as: run a pod named nginx-dev using nginx latest image in dev namespace.
   <!-- kubectl run nginx-prod --image=nginx:latest -n production -->
   kubectl run nginx-staging --image=nginx:latest -n staging

4. kubectl get pods -A
5. kubectl get pods # this searches for pods in default namespace
   

-------------------------------------------------------------------------------
Task 3: creating deployment

1.  kubectl create deployment nginx-deploy --image=nginx:latest -n dev
    kubectl get depolyments -n dev

    kubectl get pods -n dev 
    # we see that actually a new POD is created. Thus deployment creates a new POD

2. why is deployment better?
   - even is we delete the POD, new POD is created.
   - desired state is maintained
   - kubectl delete pod <pod_name> -n staging
   - a new pod is created again

3. vi nginx-deployment.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx

spec: 
  replicas: 3

  selector:
    matchLabels:
      app: nginx

  template:
    metadata:
      labels:
        app: nginx

    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80



kubectl apply -f nginx-deployment.yml

-------------------------------------------------------------------------------
Task 4: Self-healing

1. kubectl get pods -n dev
   kubectl delete pod nginx-deployment-7bb7cd8db5-j2fvm -n dev


2. the replacement pods name is different
3. deployment creates completely new pod

-------------------------------------------------------------------------------
Task 5: Scaling Deployment

1. kubectl get deployment nginx-deploy -n dev
   kubectl scale deployment nginx-deploy --replicas=5 -n dev

   kubectl get deployments -n dev
   kubectl get pods -n dev

   we see multiple replicas running

2. Scale down to 2:
   kubectl scale deployment nginx-deployment --replicas=2 -n dev
   kubectl get pods -n dev

-------------------------------------------------------------------------------
Task 6: rolling update
1. kubectl set image deployment/nginx-deploy nginx=nginx:1.25 -n dev
   kubectl rollout status deployment/nginx-deploy -n dev

   kubectl rollout history deployment/nginx-deployment -n dev
   kubectl rollout undo deployment/nginx-deployment -n dev

   kubectl describe deployment nginx-deployment -n dev | grep image
   kubectl get rs -n dev # relicaSets
   kubectl get pods -n dev

   kubectl get pods -A
   kuebctl get deployments -A
   kuebctl get ns

rollout = rollback (to go to prev stable version)

-------------------------------------------------------------------------------
Task 7: Cleanup

1. kubectl delete deployement nginx-deployment -n dev
   kubectl delete pod nginx-dev -n dev
   kubectl delete pod nginx-staging -n staging
   kubectl delete namespace dev staging production

2. kubectl get namespaces
   kubectl get pods
   kubectl get deployments 

3. if you delete deployment, all pods will be deleted (belonging to that deployment)
   Deployment
    ↓
   ReplicaSet
    ↓
   Pods

qs. if i created a pod separately without deployment. then if i delete deployment, will the pod also get deleted?
Ans. Deployment-created pod -> deployment delete hone par delete hoga
Standalone pod (kubectl run ... --restart=Never) -> deployment delete se affect nahi hoga

4. If I delete a Namespace, will Pods and Deployments auto-delete? - YES
   kubectl delete namespace dev
   Everything inside dev gets deleted automatically.

5. Namespaces:
A. kube-system: contains core k8s components:
   coredns
   kube-apiserver
   kube-scheduler
   kube-controller-manager
   etcd
   kube-proxy

B. kube-public:
   stores publically readable cluster info

c. kube-node-release:
   used for node-heartbeats
   can effect status tracking

d. local-path-storage
   dynamically creates persistent volumes
   existing storage-backed apps may delete
   



