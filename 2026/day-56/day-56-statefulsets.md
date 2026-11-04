
-------------------------------------------------------------------------------------------------
Task 1: understanding the problem

1. vi deployment.yml
   
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
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
        image: nginx

2. kubectl apply -f deployment.yaml
   kubectl get pods

   - we see the POD names are Random
  
3. deleting one pod:
   kubectl delete pod nginx-deploy-5743cv495ad-rx6877590
   one pod gets deleted and another one is created with diff name

- If the new pod gets a new name then cluster members would find it difficult to identify each others
- DB-nodes need permanent identity
- cluster members rely on stable identity and hostname for communicatioin and replication


-------------------------------------------------------------------------------------------------
Task 2: Creating Headless Service

providing stable DNS name to statefulSet

1. vi headless-service.yml

apiVersion: v1
kind: Service
metadata:
    name: nginx-headless
spec:
    clusterIP: None
    selector:
        app: web
    ports:
        - port: 80

2. kubectl apply -f headless-service.yml
   kubectl get svc

   - clusterIp column for headless-service shows: None

3. headless service creates a DNS record for each Pod
   
-------------------------------------------------------------------------------------------------
Task 3: Creating StatefulSet : creating stable pods and PVCs

1. vi statefulset.yml

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: nginx-headless
  replicas: 3
  selector:
    matchLabels:
      app: web

  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx

        volumeMounts:
        - name: web-data
          mountPath: /usr/share/nginx/html

  volumeClaimTemplates:
  - metadata:
      name: web-data
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi

2. kubectl apply -f statefulset.yml
   kubectl get pods -l app=web -w

3. kubectl get pods
   kubectl get pvc

-------------------------------------------------------------------------------------------------
Task 4: Stable Network Identity: each pod must have stable DNS

1. DNS pattern: 
   <pod-name>.<service-name>.<namespace>.svc.cluster.local

2. running busybox:
   kubectl run busybox --image=busybox --restart=Never -it -- sh

   nslookup web-0.nginx-headless.default.svc.cluster.local
   nslookup web-1.nginx-headless.default.svc.cluster.local
   nslookup web-2.nginx-headless.default.svc.cluster.local

   - we get address as : 10.244.0.19, 10.244.0.21, 10.244.0.23

3. kubectl get pods -o wide
   - here also we get the same IPs

-------------------------------------------------------------------------------------------------
Task 5: Stable Storage - data must survive even if POD gets deleted

1. kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/html/index.html"
   kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
   - we see that the data or changes are reflected in the file

2. kubectl delete pod web-0
   - now the StatefulSet will automatically re-create the web-0 pod
  
3. kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
   - data is still present even after deleting te web-0 POD
   - WHY?
     - Because the Pod got deleted but PVC still exists. The new pod gets attached to same PVC
  
-------------------------------------------------------------------------------------------------
Task 6: Ordered Scaling - sequential scaling by statefulset

1. kubectl scale statefulset web --replicas=5
   kubectl get pods
   
2. kubectl scale statefulset web --replicas=3
   kubectl get pods

   - still we see all 5 PVCs exists
   - this is so as when we scale-up in future then we can get the data
   - PVC exists even after Scale-Down, Pod do not exist
   - k8s retains PVC as it hold the state/data of the POD


-------------------------------------------------------------------------------------------------
Task 7: CleanUp

1. kubectl delete statefulset web
2. kubectl delete svc nginx-headless
   kubectl get svc
   kubectl get pvc

   - we see that the PVC still exist

3. deleting PVC manually:
   kubectl delete pvc --all

Note: Even if you delete the StatefulSet, the PVC does not get auto deleted

--------------------------------------------------------------------------------------------------

- StatefulSets are K8s workloads used for applications requiring stable identity, persistent storage and ordered deployment
- each pod gets its own PVC
- Stable Pod Names, DNS resolution, Persistent Storage, Ordered Scaling (all this is not provided by Deployment)
- Stable Pod names are achieved via StatefulSet, (K8s automatically names the Pods)
- web-0, web-1, web-2  (here web= name of StatefulSet)