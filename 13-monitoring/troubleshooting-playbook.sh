#!/bin/bash

# ─────────────────────────────────────────────────────────────
# 1. CLUSTER HEALTH CHECK
# ─────────────────────────────────────────────────────────────
echo "=== Cluster Health ==="
kubectl get nodes
kubectl get componentstatuses 2>/dev/null || echo "cs deprecated in 1.19+"
kubectl cluster-info

echo "=== System Pods ==="
kubectl get pods -n kube-system

echo "=== All Namespaces Overview ==="
kubectl get pods --all-namespaces | grep -v Running | grep -v Completed

# ─────────────────────────────────────────────────────────────
# 2. NAMESPACE HEALTH
# ─────────────────────────────────────────────────────────────
NAMESPACE=${1:-default}
echo "=== Namespace: $NAMESPACE ==="

kubectl get all -n $NAMESPACE
kubectl top pods -n $NAMESPACE 2>/dev/null
kubectl get events -n $NAMESPACE \
  --sort-by='.lastTimestamp' | tail -20

# ─────────────────────────────────────────────────────────────
# 3. POD DEEP DIVE
# ─────────────────────────────────────────────────────────────
POD=${2:-""}
if [ -n "$POD" ]; then
  echo "=== Pod: $POD ==="
  kubectl describe pod $POD -n $NAMESPACE
  kubectl logs $POD -n $NAMESPACE --tail=100
  kubectl logs $POD -n $NAMESPACE --previous 2>/dev/null \
    && echo "(previous logs found)"
fi

# ─────────────────────────────────────────────────────────────
# 4. RESOURCE PRESSURE CHECK
# ─────────────────────────────────────────────────────────────
echo "=== Resource Usage ==="
kubectl top nodes
kubectl top pods --all-namespaces \
  --sort-by=memory 2>/dev/null | head -15

# ─────────────────────────────────────────────────────────────
# 5. NETWORKING CHECK
# ─────────────────────────────────────────────────────────────
echo "=== Services & Endpoints ==="
kubectl get svc -n $NAMESPACE
kubectl get endpoints -n $NAMESPACE
kubectl get ingress -n $NAMESPACE 2>/dev/null
