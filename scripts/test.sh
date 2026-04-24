#!/bin/bash
echo "=== TaskApp Health Tests ==="

echo "Testing backend health..."
BACKEND_POD=$(kubectl get pod -n taskapp -l app=backend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it ${BACKEND_POD} -n taskapp -- curl -s http://localhost:5000/api/health

echo ""
echo "Testing database connection..."
POSTGRES_POD=$(kubectl get pod -n taskapp -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it ${POSTGRES_POD} -n taskapp -- pg_isready -U taskapp

echo ""
echo "Testing frontend..."
FRONTEND_POD=$(kubectl get pod -n taskapp -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it ${FRONTEND_POD} -n taskapp -- curl -s http://localhost/health

echo ""
echo "=== All Tests Complete ==="
