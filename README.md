Gitlab integration with ACM

Edit secret.yaml
git update-index --assume-unchanged secret.yaml

oc create -f multi-cloud.yaml -f secret.yaml --save-config
# GitLab CI Demo

Demonstrate how to build/deploy a container to OpenShift via GitLab Auto DevOps

## Source

There's an example hello world app written in golang

### Run

```sh
go run main.go
```

### Build

```sh
go build . -o main
```
