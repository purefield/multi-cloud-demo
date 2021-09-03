Gitlab integration with ACM

Edit secrets.yaml
git update-index --assume-unchanged secrets.yaml

```sh
Create Access Token with api role
kubectl create secret docker-registry gitlab-registry-auth \
        --docker-server=registry.gitlab.com \
        --docker-username=openshift-token\
        --docker-password=token\
        --docker-email=user@domain.tld
kubectl create secret docker-registry gitlab-repo-auth \
        --docker-server=gitlab.com \
        --docker-username=openshift-token\
        --docker-password=token\
        --docker-email=user@domain.tld
oc secrets link default gitlab-registry-auth --for=pull
oc secrets link default gitlab-repo-auth --for=pull
```
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
