source ./format.sh
oc config use-context acm
clusters=($(oc config get-contexts -o name | sort | perl -pe 's/acm/local-cluster/'| grep -v '\:'))
cluster1=${clusters[0]}
cluster2=${clusters[1]}
cluster3=${clusters[2]}
cluster4=${clusters[3]}
cluster5=${clusters[4]}

__ "Resume $cluster3 cluster from hibernation"
oc patch clusterdeployment $cluster3 -n $cluster3 --type merge -p '{"spec": {"powerState": "Running"}}'
oc wait clusterdeployment/$cluster3 -n $cluster3 --for=jsonpath='{.status.powerState}'=Running --timeout=60s

___ "Remove app-env-hello labels"
oc label ManagedCluster --all app-env-hello-

___ "Add app-env-hello labels to on-prem clusters"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster5 app-env-hello=development

___ "Add app-env-hello label for development to $cluster2"
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=development

___ "Add app-env-hello label for development to $cluster3"
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=development

___ "Add app-env-hello label for development to $cluster4"
oc label ManagedCluster --overwrite=true -l name=$cluster4 app-env-hello=development

___ "Move cluster $cluster2 to production"
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=production

___ "Move cluster $cluster3 to production"
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=production

___ "Move cluster $cluster4 to production"
oc label ManagedCluster --overwrite=true -l name=$cluster4 app-env-hello=production

___ "Remove app from cluster $cluster1"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello-

___ "Remove app from cluster $cluster3"
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello-

___ "Hibernate cluster $cluster3"
oc patch clusterdeployment $cluster3 -n $cluster3 --type merge -p '{"spec": {"powerState": "Hibernating"}}'

exit 0

___ "Create code change"
git checkout development
perl -pe 's/(VERSION\D+)\d+$/${1}2/' -i server.js
git diff server.js
___ "Push change to development"
git commit -m 'Version bump' server.js; git push gitlab development
