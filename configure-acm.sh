echo "Run"
echo "cd /srv/; . ./login.sh; oc-sync-login; cd -"
oc delete -f multi-cloud/app.yaml -f multi-cloud/gitlab-secrets.yaml -f secrets.yaml
git update-index --assume-unchanged secrets.yaml

# Create project and namespace
oc create -f multi-cloud/app.yaml -f multi-cloud/gitlab-secrets.yaml --save-config

# Create Access Token with api role
oc project gitlab-auth
oc delete secret gitlab-registry-auth
oc delete secret gitlab-repo-auth
kubectl create secret docker-registry gitlab-registry-auth \
        --docker-server=registry.gitlab.com \
        --docker-username=openshift-token\
        --docker-password=$token\
        --docker-email=$email
kubectl create secret docker-registry gitlab-repo-auth \
        --docker-server=gitlab.com \
        --docker-username=openshift-token\
        --docker-password=$token\
        --docker-email=$email
oc secrets link default gitlab-registry-auth --for=pull
oc secrets link default gitlab-repo-auth --for=pull

gitlabRegistryAuth=$(oc get secret gitlab-registry-auth -o=jsonpath='{ .data.\.dockerconfigjson }')
gitlabRepoAuth=$(oc get secret gitlab-repo-auth -o=jsonpath='{ .data.\.dockerconfigjson }')
perl -pe "s/GITLAB_REGISTRY_AUTH/$gitlabRegistryAuth/" secrets.yaml.tmpl | \
perl -pe "s/GITLAB_REPO_AUTH/$gitlabRepoAuth/" |
perl -pe "s/GITLAB_ACCESS_TOKEN/$token/"> secrets.yaml
oc apply -f secrets.yaml
oc secrets link default gitlab-access-token --for=pull

# import logins
. /srv/login.sh
oc-login acm

# names
cluster1="local-cluster"
oc label ManagedCluster -l name=$cluster1 usage=gitlab --overwrite=true
for i in 2 3 4 5; do
  cluster=$(echo ${clusters[$i]} | cut -d\. -f1)
  oc label ManagedCluster -l name=$cluster usage=gitlab --overwrite=true
done
for i in 2 3 4 5; do
  oc-login $i
  oc create namespace gitlab-auth
  oc project gitlab-auth
  oc apply -f secrets.yaml
  oc secrets link default gitlab-access-token --for=pull
done

./setup.sh
echo run ./demo.sh
