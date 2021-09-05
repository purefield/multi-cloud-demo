Gitlab integration with ACM

Edit secrets.yaml
git update-index --assume-unchanged secrets.yaml

Create Access Token with api role
Create Secret and link to default account on each cluster
```sh
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
oc secrets link default gitlab-registry-auth -n multi-cloud --for=pull
oc secrets link default gitlab-repo-auth     -n multi-cloud --for=pull
```
```sh
oc create -f multi-cloud/app.yaml -f secrets.yaml --save-config
oc secrets link default gitlab-access-token --for=pull -n multi-cloud
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
