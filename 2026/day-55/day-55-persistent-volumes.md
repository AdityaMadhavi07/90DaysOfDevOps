Persistent VOlumes and Persistent Volume Claims

Pv: cluster level storage resource
Pvc: storage request asked by POD

WHY?
because the pods are emphermal 

---------------------------------------------------------------------------
Task 1: demonstaring data loss

1. vi ephemeral

apiVersion: v1
kind: Pod
metadata:
  name: ephemeral-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        date > /data/message.txt
        sleep 3600
    volumeMounts:
    - mountPath: /data
      name: temp-storage

  volumes:
  - name: temp-storage
    emptyDir: {}

2. kubectl apply -f ephemeral-pod.yaml
3. checking file:
   kubectl exec -it ephemeral-pod -- cat /data/message.txt
4. kubectl delete pod ephemeral-pod.yaml 
   kubectl delete pod expects a pod name, not a YAML filename. Kubernetes looked for a pod named ephemeral-pod.yaml and couldn't find it.
   kubectl delete pod ephemeral-pod
5. kubectl apply -f ephemeral-pod.yaml
   kubectl exec -it ephemeral-pod -- cat /data/message.txt


If /data is backed by an emptyDir volume, you'll see a new timestamp, because emptyDir data is removed when the pod is deleted and recreated.
If the age resets to a few seconds after recreation, it's a new pod and the ephemeral storage has been recreated as well.

---------------------------------------------------------------------------
Task 2:  creating persistent volumes:

1. vi pv.yaml
   
apiVersion: v1
kind: PersistentVolume
metadata:
  name: static-pv
spec:
  capacity:
    storage: 1Gi

  accessModes:
    - ReadWriteOnce
  
  storageClassName: ""
  persistentVolumeReclaimPolicy: Retain

  hostPath:
    path: /tmp/k8s-pv-data

1. kubectl apply -f pv.yaml
2. kubectl get pv
we see the status of static pv as available as, no pvc has claimed it uptil now

---------------------------------------------------------------------------
Task 3: Creating PVC

1. vi pvc.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-pvc
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce

  resources:
    requests:
      storage: 500Mi


2. kubectl apply -f pvc.yaml
3. kuebctl get pvc

note: resources.requests is attribute/field of PVC

cluster by default assigns storageClass (standard) automatically to PVC
both need a matching criteria. do not use dynamic provisioning. we need to bind the pv to existing PVC
k8s controller compares PV and PVC 
    - the accessModes = RWO
    - the requested storage is less than PV capacity = (500Mi < 1Gi)
    - storage class match = ""==""
---------------------------------------------------------------------------

Task 4: Using PVC in POD

1. vi pv-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: pv-pod
spec:
  containers:
    - name: app
      image: busybox
      command:
        - sh
        - -c
        - |
          echo "First Pod $(date)" >> /data/message.txt
          sleep 3600

      volumeMounts:
        - name: storage
          mountPath: /data

  volumes:
    - name: storage
      persistentVolumeClaim:
        claimName: static-pvc

2. kubectl apply -f pv-pod.yaml
   kubectl exec -it pv-pod -- cat /data/message.txt

3. kubectl delete pod pv-pod
   
4. echo "Second Pod $(date)" >> /tmp/k8s-pv-data/message.txt
   kubectl exec -it pv-pod -- cat /data/message.txt

pvc acts as a bridge between POD and Storage
---------------------------------------------------------------------------
Task 5: StorageClass understanding

1. kubectl get storageClass
2. kubectl describe storageclass standard

---------------------------------------------------------------------------
Task 6: Dynamic Provisioning

1. 
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  storageClassName: standard

  accessModes:
   - ReadWriteOnce


  resources:
   requests:
    storage: 500Mi

2. kubectl apply -f dynamic-pvc.yml
   kubectl get pvc
   
3. kubectl get pv

    - The dynamic PVC stays in pending state because k8s does not get matching PV for the PVC. Also dynamic provisioning does not work.
    - when we write storageClassName: standard in PVC, k8s must automatically create PV.
    - if the cluster does not have storageClass/Provisioner configured, then PV wont be created

    - pvc is pending as VolumeBingingMode of storageClass is WaitForFirstConsumer. K8s wont bind/create PV until any POD uses this PVC. so we first create a Pod then Pv created. So that its the POD who will use the PV
  
4. creating dynamic-pod.yml
   
apiVersion: v1
kind: Pod
metadata:
  name: dynamic-pod
spec:
  containers:
  - name: app
    image: busybox
    command:
      - sh
      - -c
      - |
        echo "Dynamic Data" >> /data/message.txt
        sleep 3600

    volumeMounts:
    - mountPath: /data
      name: storage

  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: dynamic-pvc
    
5. kubectl apply -f dynamic-pod.yml
   kubectl exec -it dynamic-pod -- cat /data/message.txt 

   Note:
   - in Static Provisioning, Admin makes the PV --> uses the PVC
   - in Dynamic Provisioning, developer only creates PVC, storage class + provisioner automatically creates PV

---------------------------------------------------------------------------
Task 7: CleanUp

1. kubectl delete pod pv-pod
   kubectl delete pod dynamic-pod
2. kubectl delete pvc static-pvc
   kubectl delete pvc dynamic-pvc


---------------------------------------------------------------------------
Note:

Static provisioning:
- K8s controller works in BG and compares the 
  - accessModes
  - storage 
  - if PV is available/free
- if all matches then pvc auto-binds to PV

Dynamic Provisioning
- pvc --> storageClass --> provisioner --> pv create --> pvc bound
- pvc claims a pv from the storageClass. 
- storageClass makes the provisioner create a PV
- PV created is alloted to PVC
- in dynamic provisioning, we need to create a POD first, then the PV will be created





