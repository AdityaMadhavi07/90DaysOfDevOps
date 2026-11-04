-----------------------------------------------------------------------------------------------------------
Task 1: Resource requests and Limits

   Requests - minimum guarantee, used by scheduler for placement
   Limits - maximum allowed usage, enforced by kubelet at runtime

1. vi resource-demo.yml
   
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "250m"
        memory: "256Mi"


2. kubectl apply -f resource-demo.yml
3. kubectl describe pod resource-demo
   
   - QOS Class: Burstable
     - as request != limit (burstable), burstable means it is flexible upto a limit, it can burst and increase upto a limit
     - request = limit (guaranteed)
     - nothing specified = besteffort

-----------------------------------------------------------------------------------------------------------
Task 2: oomkilled - exeeding memory limits

if you overuse CPU = system will throttle 
if you overuse memory = container will be killed

1. vi oom-demo.yml

apiVersion: v1
kind: Pod
metadata:
  name: oom-demo
spec:
  containers:
    - name: stress
      image: polinux/stress
      command: ["stress"]
      args:
        - "--vm"
        - "1"
        - "--vm-bytes"
        - "200M"
        - "--vm-hang"
        - "1"
      resources:
        limits:
          memory: "100Mi"

2. kubectl apply -f oom-demo.yml
   kubectl get pod -w

   - we see CrashLoopBackOff
  
3. kubectl describe pod oom-demo
   - we see Reason: OOMKilled 
   - Exit Code: 137  [128+9(SIGKILL)]..linux kills process forcefully

Note: when we exeed the memory usage, K8s will kill the container (oomkilled). This demonstrates the memory enforcement behavior

-----------------------------------------------------------------------------------------------------------
Task 3: Pending pod requesting too much

K8s scheduller checks the resource availability. If resources are unavailable, the POD is not scheduled

1. vi huge-request.yml

apiVersion: v1
kind: Pod
metadata:
  name: huge-request
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        cpu: "100"
        memory: "128Gi"

2. kubectl apply -f huge-request.yml
   kubectl get pod
   
3. kubectl describe pod huge-request
   - under events we see insufficient cpu and memory

Note: we created Pod with unrealistic resource requests. The Pod remained in Pending state, and scheduler events indicated insufficient memory and resources

-----------------------------------------------------------------------------------------------------------
Task 4: Liveness Probe

Make k8s detect the unhealthiness of app . if liveness fails, container restarts

1. vi liveness.yaml

apiVersion: v1
kind: Pod
metadata:
  name: liveness-demo
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy;
      sleep 30;
      rm -f /tmp/healthy;
      sleep 600;
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      periodSeconds: 5 # liveness probe is checked every 5 secs
      failureThreshold: 3 # after 3 consequetive failures, k8s declares container as unhealthy

2. kubectl apply -f liveness.yaml

3. kubectl get pod -w
   - after 30 sec, file gets deleted --> probe fails 
   - after 3 failures --> container restarted

4. kubectl describe pod liveness-demo
   kubectl get pod

   - we see the restart count- 5

Note:
Implemented a liveness probe using an exec check. After intentionally deleting the health file, the probe failed repeatedly and Kubernetes automatically restarted the container, demonstrating self-healing behavior.


-----------------------------------------------------------------------------------------------------------
Task 5: Readiness Probe - traffic control

1. vi readiness.yaml

apiVersion: v1
kind: Pod
metadata:
  name: readiness-demo
  labels:
   app: readiness-demo
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 5

2. kubectl apply -f readiness.yaml

3. creating service:
   kubectl expose pod readiness-demo --port=80 --name=readiness-svc
   kubectl get endpoints readiness-svc

4. Breaking readiness:
   kubectl exec readiness-demo -- rm /usr/share/nginx/html/index.html
   kubectl get pod
   - 0/1 ready
  
5. checking endpoints
   kubectl get endpoints readiness-svc
   - <none>
   - we see that container is still working, no restart

Note: if readiness fails , container does not restart
Configured a readiness probe for an NGINX Pod and verified that probe failure only removed the Pod from Service endpoints. The container continued running, confirming that readiness checks control traffic rather than container lifecycle.

A readiness probe was configured for an NGINX Pod to determine whether it was ready to receive traffic. When the application became unavailable, Kubernetes removed the Pod from the Service endpoints but did not restart the container, demonstrating how readiness probes control traffic routing without affecting container lifecycle.

-----------------------------------------------------------------------------------------------------------
Task 6: Startup Probe - giving extra time to slow-start apps to complete their start-up

1. If Startup Probe is enabled/active, then:
   readiness disabled + liveness disabled

2. 
apiVersion: v1
kind: Pod
metadata:
  name: startup-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command:
    - /bin/sh
    - -c
    - sleep 20 && touch /tmp/started && sleep 300

    startupProbe:
      exec:
        command:
        - cat
        - /tmp/started
      periodSeconds: 5
      failureThreshold: 12

    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/started
      periodSeconds: 5

Note: A startup probe was configured for a slow-starting container that required 20 seconds to initialize. The probe delayed liveness and readiness checks until startup completed successfully. This prevented premature container restarts and ensured the application had sufficient time to become operational before health monitoring began.

-----------------------------------------------------------------------------------------------------------
Task 7: CleanUp

1. kubectl delete pod resource-demo
   kubectl delete pod oom-demo
   kubectl delete pod huge-request
   kubectl delete pod liveness-demo
   kubectl delete pod readiness-demo
   kubectl delete pod startup-demo

2. kubectl delete svc readiness-svc
   kubectl get pods
   kubectl get svc

-----------------------------------------------------------------------------------------------------------
Note:
- CPU limit exceeded:
  - container is throttled + continues running
- Memory Limit Exceeded:
  - container terminated + OOMKilled + 137 exit code

- Qos Classes:
  - guaranteed when requests = limits
  - burstable when requests < limits
  - besteffort when request and limits are not configured

Probes:
- liveness Probe:
  - detect unhealthy container, retsart on failure

- readiness Probe:
  - decides if Pod should recieve traffic
  - removes POD from service endpoints, does not restart container

- startup Probe:
  - handles slow-starting apps, by giving extra startup-time 
  - disables liveness and readiness until successful

