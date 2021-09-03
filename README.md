Gitlab integration with ACM

Edit secrets.yaml
git update-index --assume-unchanged secrets.yaml

```sh
oc create -f multi-cloud/app.yaml --save-config
```
```sh
oc create -f secrets.yaml --save-config
```
```sh
oc create -f gitlab/config.yaml -f gitlab/runner.yaml --save-config
```

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
