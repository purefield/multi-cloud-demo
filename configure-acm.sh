echo "Run"
echo "cd /srv/; . ./login.sh; oc-sync-login; cd -"
oc delete -f multi-cloud/app.yaml -f secrets.yaml # -f multi-cloud/gitlab-secrets.yaml
oc wait --for=delete ns/multi-cloud -A 
git update-index --assume-unchanged secrets.yaml

# Create project and namespace
oc create --save-config -f multi-cloud/app.yaml # -f multi-cloud/gitlab-secrets.yaml
oc wait --for=jsonpath='{.status.phase}'=Active ns/multi-cloud

# Create Access Token with api role
source gitlab.token
oc project gitlab-auth
oc delete secret gitlab-registry-auth
oc delete secret gitlab-repo-auth
oc wait --for=delete secret/gitlab-repo-auth -A
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

./setup.sh
echo run ./demo.sh
