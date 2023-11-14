# Cert-manager DNSMadeEasy webhook

This is a cert-manager webhook for the DNSMadeEasy. It is used to get Let´s encrypt certificates using DNSMadeEasy as DNS resolver.

## !Note of origin

This project was previously forked from [Cert manager webhook dnsmadeeasy](https://github.com/angelnu/cert-manager-webhook-dnsmadeeasy) but never merged to the upstream. This repo fixes unability to find 2 and more level nested subdomains under the most specific requested domain, e.g. if you want to create cert for test.sub.your.tld but you don't have sub.your.tld zone defined, the webhook won't work and will fail to find domainID. Since the original repo is deprecated, we are publishing this just in case someone might need to support dnsmadeeasy and doesn't have spare time to migrate to more capable DNS provider like Cloudflare :relieved:.

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

## Create a new release

Use the GitHub releases to tag a new version. The workflow should then build and upload a new version matching the tag.
