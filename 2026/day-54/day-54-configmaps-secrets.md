decoupling app config from container image.
In real projects, values like DB URLs, API keys, ports, and feature flags change often. If these are hardcoded in the Docker image, every change requires an image rebuild.

Kubernetes solves this with:

ConfigMap for non-sensitive configuration
Secret for sensitive data (passwords, tokens, API keys)

----------------------------------------------------------------------------
Task 1: creating config from literals

1. creating config map:
   kubectl create configmap app-config --from-literal=APP_ENV=production --from-literal=APP_DEBUG=false --from-literal=APP_PORT=8080
   #configmap got created and has 3 key-value pairs stored: APP_ENV,DEBUG AND PORT
   the runtime info gets stored in config cluster instead of image

   WHAT?
   CofigMap is an object of K8s which stores non-sensitive config info like- 
        - app mode
        - port
        - ft. logs
        - URLs
   WHY?
   - to keep the config separated from the docker-image
  
2. kubectl describe configmap app-config
3. kubectl get configmap app-config -o yaml

----------------------------------------------------------------------------
Task 2: creting configmap from file

1. vi default.conf

server{
    listen 80;

    location / {
        return 200 "Nginx Running";
    }

    location /health {
        return 200 "healthy";
    }
}

2. kubectl create configmap nginx-config --from-file=default.conf=default.conf
3. kubectl get configmap nginx-config -o yaml


----------------------------------------------------------------------------
Task 3: using configmaps in a Pod

Injecting configmap as env variable:
1. vi busybox-configmap.yaml

apiVersion: v1
kind: Pod
metadata:
  name: busybox-config
spec:
  containers:
  - name: busybox
    image: busybox
    command:
      - sh
      - -c
      - |
        echo APP_ENV=$APP_ENV;
        echo APP_DEBUG=$APP_DEBUG;
        echo APP_PORT=$APP_PORT;
        sleep 3600
    envFrom:
    - configMapRef:
        name: app-config

2. kubectl apply -f busybox-configmap.yaml
3. kubectl logs busybox-config

4. vi nginx-config-pod.yaml

apiVersion: v1
kind: Pod

metadata:
  name: nginx-config-pod

spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/conf.d

  volumes:
    - name: nginx-config-volume
      configMap:
        name: nginx-config

5. kubectl apply -f nginx-config-pod.yaml
   kubectl exec nginx-config-pod -- ls /etc/nginx/conf.d

6. Port forwarding:
   kubectl port-forward nginx-config-pod 8080:80

   o/p - healthy

----------------------------------------------------------------------------
Task 4: create a Secret

1. kubectl create secret generic db-credentials \
   --from-literal=DB_USER=admin \
   --from-literal=DB_PASSWORD=S3cureP@ssw0rd

2. kubectl get secret db-credentials -o yaml
   # we see the credentials are base64 encodeed

3. decoding pwd:
   kubectl get secret db-credentials \
   -o jsonpath='{.data.DB_PASSWORD}'
   O/P:
   UzNjdXJlUEBzc3cwcmQ=
   echo 'UzNjdXJlUEBzc3cwcmQ=' | base64 --decode
   o/p:
   s3cureP@ssw0rd

----------------------------------------------------------------------------
Task 5: using secrets in Pod

1. vi secret-pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: secret-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command:
      - sh
      - -c
      - sleep 3600

    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: DB_USER

    volumeMounts:
    - name: db-secret-volume
      mountPath: /etc/db-credentials
      readOnly: true

  volumes:
  - name: db-secret-volume
    secret:
      secretName: db-credentials

2. kubectl apply -f secret-pod.yml
3. kubectl exec secret-demo -- printenv DB_USER # checking env variable
4. kubectl exec secret-demo -- ls /etc/db-credentials # checking mounted files
5. kubectl exec secret-demo -- cat /etc/db-credentials/DB_USER # reading values
6. kubectl exec secret-demo -- cat /etc/db-credentials/DB_PASSWORD
7. 
----------------------------------------------------------------------------
Task 6: updating configmap and observe propagation

1. creating configmap:
   kubectl create configmap live-config --from-literal=message=hello

2. creating pod: vi live-config-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: live-config-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command:
      - sh
      - -c
      - |
        while true
        do
          cat /config/message
          sleep 5
        done

    volumeMounts:
    - name: live-config-volume
      mountPath: /config

  volumes:
  - name: live-config-volume
    configMap:
      name: live-config

3. kubectl apply -f live-config-pod.yaml
   kubectl logs -f live-config-pod
   
4. updating config map:
   kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'

5. configmap when ounted as volume, Auto-Updates
   configmap when mounted as env variable, does not aut-update, we need to restart the POD


----------------------------------------------------------------------------
Task 7: clean up

1. deleting pods:
   kubectl delete pod busybox-config
   kubectl delete pod nginx-config-pod
   kubectl delete pod secret-demo
   kubectl delete pod live-config-pod

   deleting configMaps:
   kubectl delete pod configmap app-config
   kubectl delete pod configmap nginx-config
   kubectl delete pod configmap live-config

   kubectl delete secret db-credentials

------------------
ConfigMap/Secret mounted as volume auto-update hote hain, but environment variables pod startup ke time set hote hain aur automatically update nahi hote. ✅





