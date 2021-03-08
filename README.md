# Cert-manager DNSMadeEasy webhook

This is a cert-manager webhook for the DNSMadeEasy. It is used to get Let´s encrypt certificates using DNSMadeEasy as DNS resolver.

## Deploying the webhook

Use the [k8s-at-home helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/dnsmadeeasy-webhook )

## Building the code

```bash
docker build --build-arg -t dnsmadeeasy-webhook  dnsmadeeasy-webhook 
```

or if you want build and test the code:

```bash
docker build --build-arg TEST_ZONE_NAME=<your domain>. -t dnsmadeeasy-webhook dnsmadeeasy-webhook 
```

Before you can run the test suite, you need to set your `apykey.yaml`with your DNSMadeEasy API key. See [instructions](testdata/dnsmadeeasy/README.md).

## Increment the version

Update string in [.version](.version).