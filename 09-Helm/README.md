# Implement retailstore with Helm

## Deploy http ingress

```bash
cd ingress
kubectl apply -f 01_ingress_http_instance_mode.yaml
kubectl apply -f 02_ingress_http_ip_mode.yaml
cd retailstore-apps/
```
## Install the services with Helm

```bash
# Catalog
helm install catalog oci://public.ecr.aws/aws-containers/retail-store-sample-catalog-chart \
  --version 1.3.0 -f values-catalog.yaml

# Cart
helm install cart oci://public.ecr.aws/aws-containers/retail-store-sample-cart-chart \
  --version 1.3.0 -f values-cart.yaml

# Checkout
helm install checkout oci://public.ecr.aws/aws-containers/retail-store-sample-checkout-chart \
  --version 1.3.0 -f values-checkout.yaml

# Orders
helm install orders oci://public.ecr.aws/aws-containers/retail-store-sample-orders-chart \
  --version 1.3.0 -f values-orders.yaml

# UI (Ingress enabled, HTTP — see values-ui.yaml)
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 -f values-ui.yaml
```

## Verification

```bash

# Verify Helm release
helm list

# Verify Pods / Services / Ingress
kubectl get pods
kubectl get svc
kubectl get ingress

# UI release details
helm get manifest ui
helm get manifest catalog 
helm get manifest cart 
helm get manifest checkout 
helm get manifest orders 

# Verify Ingress Load Balancer Controller Logs
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller -f
```

## Cleanup

```bash

## Uninstall retail store application
helm uninstall ui orders checkout cart catalog

## Cleanup Ingress
cd ingress
kubectl delete -f 01_ingress_http_instance_mode.yaml
kubectl delete -f 02_ingress_http_ip_mode.yaml

```