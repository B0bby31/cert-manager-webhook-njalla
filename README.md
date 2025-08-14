# cert-manager-webhook-njalla
cert-manager ACME DNS01 Webhook Solver for Njalla DNS

## Prerequsites
(Lower versions may work, but weren't tested.)
* Kubernetes v1.27.0+
* Cert-Manager v1.14+

## Installing

There are two ways to install the [original way](https://github.com/kekkker/cert-manager-webhook-njalla) or using my [helm chart](https://github.com/B0bby31/Helm-Charts).

## Quick Start using Helm

To deploy this into your clusters, you start by adding my repo:

```console
$ helm repo add b0bby31 https://charts.plutode.com
$ helm repo update
```

You either edit the values.yaml or only specify the necessary values (email is not necessary, but it allows you to test the deployment):

```console
$ helm install njalla-webhook b0bby31/cert-manager-webhook-njalla -n cert-manager --set groupName="acme.YOURDOMAIN" --set njalla.token="YOURAPITOKEN" --set email="LETSENCRYPTEMAIL"
```

After that, you can run a test which will install a letsencrypt staging CA and check if it can create a cert for "acme.YOURDOMAIN":

```console
$ helm test njalla-webhook -n cert-manager
```

If that succeeds, you have a working njalla-webhook provider for cert-manager.

### Issuer/ClusterIssuer

Now, you can create a production ClusterIssuer.

An example production issuer:

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
    # Enable the DNS-01 challenge provider
    solvers:
      - dns01:
          webhook:
            groupName: acme.YOURDOMAIN
            solverName: njalla
            config:
              apiKeySecretRef:
                name: njalla-secrets
                key: token
```
