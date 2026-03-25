# =================================================================
# Cluster Management — Operational Runbook
# Essential kubectl commands for day-to-day cluster management
# =================================================================

# -----------------------------------------------------------------
# CLUSTER HEALTH
# -----------------------------------------------------------------
kubectl cluster-info                                      # cluster endpoint info
kubectl get componentstatuses                             # control plane health
kubectl get nodes -o wide                                 # node status + IPs + OS
kubectl top nodes                                         # node CPU/memory usage
kubectl top pods -A --sort-by=cpu                        # all pods sorted by CPU
kubectl get events -A --sort-by='.lastTimestamp'         # recent events cluster-wide

# -----------------------------------------------------------------
# NAMESPACE OPERATIONS
# -----------------------------------------------------------------
kubectl get namespaces
kubectl create namespace my-ns
kubectl delete namespace my-ns                           # DELETES ALL RESOURCES INSIDE
kubectl describe namespace production
kubectl get resourcequota -n production
kubectl get limitrange -n production
kubectl describe resourcequota dev-quota -n development

# -----------------------------------------------------------------
# RBAC INSPECTION
# -----------------------------------------------------------------
kubectl auth can-i create pods --namespace=production                        # as yourself
kubectl auth can-i create pods --namespace=production --as=bob@company.com   # as another user
kubectl auth can-i '*' '*'                                                   # cluster-admin check
kubectl get roles,rolebindings -n development
kubectl get clusterroles,clusterrolebindings | grep -v system               # custom roles only
kubectl describe clusterrole cluster-viewer
kubectl auth reconcile -f 02-rbac.yaml                                       # apply and report changes

# -----------------------------------------------------------------
# NODE MANAGEMENT
# -----------------------------------------------------------------
kubectl get nodes --show-labels
kubectl describe node <node-name>
kubectl cordon <node-name>
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data --grace-period=60
kubectl uncordon <node-name>
kubectl taint nodes <node-name> dedicated=gpu:NoSchedule
kubectl taint nodes <node-name> dedicated=gpu:NoSchedule-                   # remove taint

# -----------------------------------------------------------------
# SCALING AND AUTOSCALING
# -----------------------------------------------------------------
kubectl scale deployment my-app --replicas=5 -n production
kubectl autoscale deployment my-app --min=2 --max=10 --cpu-percent=70
kubectl get hpa -n production
kubectl describe hpa backend-hpa -n production
kubectl get vpa -n production                                                # requires VPA installed

# -----------------------------------------------------------------
# NETWORK POLICY INSPECTION
# -----------------------------------------------------------------
kubectl get networkpolicies -n production
kubectl describe networkpolicy default-deny-ingress -n production

# -----------------------------------------------------------------
# POD DISRUPTION BUDGETS
# -----------------------------------------------------------------
kubectl get pdb -n production
kubectl describe pdb backend-pdb -n production

# -----------------------------------------------------------------
# ADMISSION CONTROLLERS
# -----------------------------------------------------------------
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
kubectl get constrainttemplates                                              # OPA Gatekeeper
kubectl get constraints                                                      # OPA Gatekeeper

# -----------------------------------------------------------------
# SECURITY AUDIT
# -----------------------------------------------------------------
kubectl get pods -A -o json | jq '.items[] | select(.spec.containers[].securityContext.privileged == true) | .metadata.name'
kubectl get pods -A -o json | jq '.items[] | select(.spec.hostNetwork == true) | .metadata.name'
kubectl get pods -A -o json | jq '.items[] | select(.spec.containers[].securityContext == null) | .metadata.name'

# -----------------------------------------------------------------
# ETCD BACKUP (run on control plane node)
# -----------------------------------------------------------------
# ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date +%F).db \
#   --endpoints=https://127.0.0.1:2379 \
#   --cacert=/etc/kubernetes/pki/etcd/ca.crt \
#   --cert=/etc/kubernetes/pki/etcd/server.crt \
#   --key=/etc/kubernetes/pki/etcd/server.key
#
# ETCDCTL_API=3 etcdctl snapshot status /backup/etcd-$(date +%F).db --write-out=table

# -----------------------------------------------------------------
# CERTIFICATE MANAGEMENT (kubeadm clusters)
# -----------------------------------------------------------------
kubeadm certs check-expiration                                              # check cert expiry
kubeadm certs renew all                                                     # renew all certs (restart control plane after)

# -----------------------------------------------------------------
# MULTI-CLUSTER / KUBECONFIG
# -----------------------------------------------------------------
kubectl config get-contexts
kubectl config use-context prod-cluster
kubectl config set-context --current --namespace=production
KUBECONFIG=~/.kube/config:~/.kube/staging.yaml kubectl config view --flatten > ~/.kube/merged.yaml
