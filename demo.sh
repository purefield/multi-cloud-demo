source /srv/login.sh
source /srv/format.sh
oc-login 1
cluster1="local-cluster"
cluster2=$(echo ${clusters[2]} | cut -d\. -f1)
cluster3=$(echo ${clusters[3]} | cut -d\. -f1)


___ "Remove app-env-hello labels"
oc label ManagedCluster --all app-env-hello-

___ "Add development app-env-hello labels"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=development

___ "Add production app-env-hello labels"
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=production

___ "Change production app-env-hello labels"
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=production
