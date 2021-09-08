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
oc create -f multi-cloud/app.yaml -f secrets.yaml --save-config
oc secrets link default gitlab-access-token --for=pull -n multi-cloud
```
```sh
cd deployment
./setup.sh
```
