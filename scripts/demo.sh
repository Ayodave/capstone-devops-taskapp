#!/bin/bash
echo "=== TaskApp Capstone Demo Script ==="
echo ""
echo "--- Cluster Status ---"
kops validate cluster --name taskapp.k8s.local
echo ""
echo "--- Nodes ---"
kubectl get nodes -o wide
echo ""
echo "--- Nodes by Zone ---"
kubectl get nodes -L topology.kubernetes.io/zone
echo ""
echo "--- Application Pods ---"
kubectl get pods -n taskapp -o wide
echo ""
echo "--- Services ---"
kubectl get svc -n taskapp
echo ""
echo "--- SSL Certificate ---"
kubectl get certificate -n taskapp
echo ""
echo "--- Ingress ---"
kubectl get ingress -n taskapp
echo ""
echo "--- HPA Status ---"
kubectl get hpa -n taskapp
echo ""
echo "--- PDB Status ---"
kubectl get pdb -n taskapp
echo ""
echo "--- Resource Usage ---"
kubectl top nodes
kubectl top pods -n taskapp
echo ""
echo "=== Demo Complete ==="
