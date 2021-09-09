# import logins
. /srv/login.sh
for clusterId in 1 2 3; do
  oc-login $clusterId
  secret=$(oc get secret gitlab-registry-auth -n multi-cloud 2>/dev/null | grep gitlab-registry-auth)
  if [ "$secret" != '' ]; then
    oc replace -f secrets.yaml 
  else
    oc create -f secrets.yaml 
  fi
  oc secrets link default gitlab-repo-auth     --for=pull -n multi-cloud
  oc secrets link default gitlab-registry-auth --for=pull -n multi-cloud
done
oc-login 1
# names
cluster1="local-cluster"
cluster2=$(echo ${clusters[2]} | cut -d\. -f1)
cluster3=$(echo ${clusters[3]} | cut -d\. -f1)

# in ACM label each cluster with their clustername:cluster1,...
#                                      clusterid=cluster1,... 
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=production
