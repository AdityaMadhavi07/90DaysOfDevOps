Task 1:

1. Docker containers run  applications. But when we need to ru n multiple applications, 1000s of containers accross multiple servers, managing them becomes difficult, thus we have K8s
k8s helps us manage containers at scale

2. k8s was created by google and then open-sourced. inpired from internal container mgmt platform called Borg

3. kubernetes= someone who steers a ship, helmsman, pilot

----------------
Task 2:

1. 
control plane/node (brain)
- user/kubectl
- API server - front door to the cluster
- etcd - db that stores all cluster state
- scheduler - decides new pod should run on which worker node
- controller manager - watches the cluster and ensures that desired state = actual state or compares the desired state and actual state and fixes the mismatch

worker node/plane (execution layer)
- kubelet - agent on each node that talks to the API server and manages pods, receives instructions from API server and rnus/monitors the POD
- container-runtime - engine that actually start/stop/pull/runs the containers (containerd/cri-o)
- service/kube-proxy proxy - handles/creates networking rules so pods can communicate   

API Server = Gate
etcd = Memory
Scheduler = Placement
Controller Manager = Auto-correct
kubelet = Executor
kube-proxy = Network handler
Runtime = Container engine

---------
kubectl apply -f pod.yml

1. kubectl sends requet to API server
2. API server validation. it checks if yml is valid, user is authorized, resource defination is correct
3. if all is correct then object is stored in ETCD
4. desired state is stored in ETCD
5. Scheduler notices new pod, it decides the (worker-node) place where the new pod should run 
6. scheduler updates the API server
7. kubelet notices the assignment (kubelet continously takes instructions from API server on worker node, it notices- new pod assignment)
8. container runtime starts the container
9. pod is running, container start, kueblet updates the status of API server from pending to running
    kubectl apply
      |
      v
 API Server
      |
      v
    etcd
      |
      v
 Scheduler
      |
      v
 Worker Node
      |
      v
   Kubelet
      |
      v
Container Runtime
      |
      v
   Running Pod

When kubectl apply -f pod.yaml is executed, the manifest is sent to the API Server, validated, and stored in etcd. The Scheduler assigns the Pod to a worker node, the Kubelet on that node detects the assignment, and the container runtime pulls the image and starts the Pod.

2. if API server goes down:
   If the API Server becomes unavailable, cluster management operations stop because it is the control-plane entry point. Existing workloads usually keep running, but new deployments, updates, and scheduling operations cannot occur.

3. if worker node goes down:
   - control plane detects failure, pods become unreahable/unavailable
   - kubernetes self-heal. if the pods are part of deployment then k8s trys to achieve the desired state
   - pods are recreated elsewhere, scheduler creates new pods on remaining healthy nodes
   - application will recover
   - if deployment/replicaSet is not used thenpod can be LOST permanently

    If a worker node fails, the Pods running on that node become unavailable. Kubernetes detects the failure and, if the Pods are managed by a Deployment or ReplicaSet, schedules replacement Pods on healthy nodes to maintain the desired state.

------------------------

Task 3: kubectl

1. kubectl is Cmd line tool for k8s

kubectl get nodes 
kubectl get pods
kubectl create deployment

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client

------------------------------

Task 4: setting up local cluster

1. KIND - kubernetes in Docker
   - faster setup
   - lightweight
   - docker based
   - less resource consumption

2. installing kind:
   curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/kind

   kind version

3. creating cluster: (control+workers)
   kind create cluster --name devops-cluster
   
   after successful creation, kubectl automatically gets connected

4. verify:
   kubectl cluster-info # api server location and coreDNS location
   kubectl get nodes # list nodes

-------------------------------

Task 5: exploring cluster:

1. 
   kubectl get nodes -o wide # detailed node info

   describing node:
   kubectl get nodes , o/p --> abcd
   kubectl describe node abcd # cpu, memory, conditions, labels, capacity, allocatable resources

2. 
   kubectl get namespaces
   kubectl get pods -A # all pods

POD   - smallest deployable unit of k8s
      - can have 1+ containers sharing same ntw + storage

Namespace   - logical partition inside the cluster
            - used to partition resources in diff groups(dev,prod,test)


3. exploring namespace:
   kubectl get pods -n kube-system


4. Architecture Component mapping:
| Pod                     | Role                               |
| ----------------------- | ---------------------------------- |
| kube-apiserver          | Cluster ka entry point             |
| etcd                    | Cluster database                   |
| kube-scheduler          | Pods ko nodes assign karta hai     |
| kube-controller-manager | Desired state maintain karta hai   |
| kube-proxy              | Networking handle karta hai        |
| CoreDNS                 | Service discovery aur DNS          |
| kubelet                 | Node agent (pod nahi, service hai) |

kubectl
                     |
                     v
          +------------------+
          | kube-apiserver   |
          +------------------+
              |    |    |
              |    |    |
              |    |    v
              |    |  etcd
              |    |
              |    v
              | kube-scheduler
              |
              v
    kube-controller-manager

                     |
                     v

   +--------------------------------+
   |            Worker Node         |
   |                                |
   |  kubelet                       |
   |  kube-proxy                    |
   |  Pods                          |
   +--------------------------------+


-----------------------------

Task 6: practicing cluster

1. deleting cluster:
   kind delete cluster --name devops-cluster
   kind get cluster

2. kind create cluster --name devops-cluster
   kind get nodes

3. Cluster-Context commands in K8s:
   kubectl config current-context
   kubectl config get-contexts # all contexts
   kubectl config use-context <name> # context switch
   context= cluster + user credentials + namespace
   this decides kubectl cmd will run on which cluster/namespace

4. kubeconfig
   kubectl config view # entire config file

   this file guides with- which cluster, which user , how to authenticate and current context

   stored in: ~/ .kube/config

   - to connect with which cluster
   - to use which user/credentials
   - context

   
