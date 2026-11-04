
---------------------------------------------------------------------------------------
Task 1: istalling metrics server

    - metrics server is a component which collects CPU/Memory usage of Nodes and Pods
    - provides metrices to HPA

1. check if metrice server exist:
   kubectl get pods -n kube-system | grep metrics-server
   - we get no o/p denoting we dont have the metric-server
  
2. installing metric-server:
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

   - now when we run this cmd: kubectl get pods -n kube-system | grep metrics-server
   - kubectl get pods -n kube-system -l k8s-app=metrics-server -w
   - we see metrics-server running

3. kubectl edit deployment metrics-server -n kube-system
   args:
   - --kubelet-insecure-tls

   -  added insecure TLS flag in container args of deployment
   -  why? as in local/lab cluster, kubelet certificate is not proper trusted, as a reason the metric-server is not connected to kubelet

4. adding local-cluster flags:
   - kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
  
5. restart and wait:
   kubectl rollout restart deployment metrics-server -n kube-system
   kubectl rollout status deployment metrics-server -n kube-system

   - we started deployment so the new-config pods also start
   - changed args will run effectively only when we create a new pod
   - 

6. sleep 60
   kubectl top nodes
   kubectl top pods -A
   
7.  kubectl top nodes
     NAME                           CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
     devops-cluster-control-plane   140m         7%       1198Mi          31%  

   - current CPU and memory usage of Node  
   - metrics collects the CPU/memory usage of nodes and pods


Note:
    - without metric-server HPA cannot perform automatic scaling

---------------------------------------------------------------------------------------
Task 2: Explore kubectl top

kubectl top always shows the Actual Usage

1. kubectl top nodes
2. kubectl top pods -A

3. kubectl top pods -A --sort-by=cpu
   - this gives most CPU consuming pod

Note:
    - kubectl top shows real-time CPU and moemory consumption collected by the metrics Server.
    - this data is use dbu HPA for scaling decisions


---------------------------------------------------------------------------------------
Task 3: Creating deployment with CPU requests

1. vi php-apache.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: php-apache
  template:
    metadata:
      labels:
        app: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m

2. kubectl apply -f php-apache.yaml
3. kubectl expose deployment php-apache --port=80
   kubectl get svc
4. kubectl top pods

Note: HPA requires CPU requests as utilization % is calculated against the requested CPU
    - to test the HPA we deployed CPU-heavy application

---------------------------------------------------------------------------------------
Task 4: Creating HPA imperatively

aim is to inc PODS if avg CPU usage goes above 50%

1. creating HPA:
   kubectl autoscale deployment php-scale --apu-percent=50 --min=1 --max=10
   kubectl get hpa
   kubectl describe hpa php-apache

   - here we state that the maximum replicas can be 10

2. understand targets:
   20%/50%

   if current cpu = 20%
   target cpu = 50%

Note:
    - HPA monitors CPU utilization and automatically adjusts replica counts. The target column shows the current utilization compared to the configured target utilization

---------------------------------------------------------------------------------------
Task 5: Load Generator

1. kubectl run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c "whle true:do wget -q -O- http://php-apache; done"
   - created load generator so it will continously send requests to the server

2. kubectl get hpa php-apache --watch
3. kubectl get pods -w


when we send traffic to the server, initially the Target column will show :
cpu: 139%/50%
then the auto-scaling will take place...
cpu: 118%/50%


4. kubectl delete pod load-generator
5. kubectl get deployment php-apache

Note:
    - when cpu utilization exceeds target threshold, HPA inc replicas. after load is removed, it gradually scales down according to stabilization policies to prevent rapid scaling fluctuations.
  
    - When we removed the load, app became almost idle. current utilization = 0% , So HPA scaled down 
    - replicas came down from 10 to 1
    - extra pods got terminated(deleted)
    - while scaling-down, container exits gracefully (exit code 0)
    - while creating HPA, we get the --max=10 (replica count)

---------------------------------------------------------------------------------------
Task 6: creating declarative HPA using YAML

1. kubectl delete hpa php-apache
   
2. vi hpa.yaml

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache

  minReplicas: 1
  maxReplicas: 10

  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0 # immediate scale-up, if load ++

    scaleDown:
      stabilizationWindowSeconds: 300 # prevents unnecessary pod flapping, 5mins wait then scale-down


3. kubectl apply -f hpa.yaml 
   kubectl describe hpa php-apache

   - behavior controls immediate scale-up. how fast HPA scales up and down
   - The behavior section in autoscaling/v2 controls scaling policies such as scale-up speed, scale-down speed, stabilization windows, and scaling limits. This provides much finer control than autoscaling/v1.
  

---------------------------------------------------------------------------------------
Task 7: CleanUp


1. kubectl delete hpa php-apache
2. kubectl delete service php-apache
3. kubectl delete deployment php-apache
4. kubectl delete pod load-generator
   
5. kubectl get all
6. kubectl delete
7. kubectl delete
8. kubectl delete
9.  kubectl delete

---------------------------------------------------------------------------------------
- metric-server: collects CPU and memory metrics from kubelets and exposes them through Mterices API
- HPA needs metric server to calulate the resource utilization abd scaling
- HPA works with deployments, statefulset and replicaSet



