# cert-manager-webhook-njalla
cert-manager ACME DNS01 Webhook Solver for Njalla DNS

## Prerequsites
(Lower versions may work, but weren't tested.)
* Kubernetes v1.27.0+
* Cert-Manager v1.14+

## Installing

```bash
kubectl apply -f https://raw.githubusercontent.com/kekkker/cert-manager-webhook-njalla/main/deploy/deployment.yaml
```
### Issuer/ClusterIssuer

Create a secret for your Njalla Api token.

```bash
kubectl create secret generic njalla-secrets -n cert-manager --from-literal=token=<NJALLA_API_TOKEN>
```

An example issuer:

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod-njalla
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: me@example.org
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod-njalla
    # Enable the HTTP-01 challenge provider
    solvers:
      - dns01:
          webhook:
            groupName: acme.yourcompany.com
            solverName: njalla
            config:
              apiKeySecretRef:
                name: njalla-secrets
                key: token
```

An example certificate:

```yaml
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example.org
  namespace: default
spec:
  secretName: example.org-tls
  issuerRef:
    name: letsencrypt-prod-njalla
    kind: ClusterIssuer
  commonName: "*.example.org"
  dnsNames:
    - "*.example.org"
```
