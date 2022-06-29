source /srv/login.sh
source /srv/format.sh
oc-login acm
cluster1=$(echo ${clusters[2]} | cut -d\. -f1)
cluster2=$(echo ${clusters[3]} | cut -d\. -f1)
cluster3=$(echo ${clusters[4]} | cut -d\. -f1)
cluster4=$(echo ${clusters[5]} | cut -d\. -f1)

___ "Remove App Subscription Report (tmp)"
oc delete appsubreport -n ocp ocp
oc delete appsubreport -n aws aws
oc delete appsubreport -n azure azure
oc delete appsubreport -n gcp gcp

___ "Remove app-env-hello labels"
oc label ManagedCluster --all app-env-hello-

___ "Add app-env-hello labels to all clusters"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=development
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=production
oc label ManagedCluster --overwrite=true -l name=$cluster4 app-env-hello=production

___ "Move cluster 2 to production"
oc label ManagedCluster --overwrite=true -l name=$cluster2 app-env-hello=production

___ "Move cluster 3 to development"
oc label ManagedCluster --overwrite=true -l name=$cluster3 app-env-hello=development

___ "Move cluster 1 to production"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello=production

___ "Remove app from cluster 1"
oc label ManagedCluster --overwrite=true -l name=$cluster1 app-env-hello-

___ "Create code change"
git checkout development
perl -pe 's/(VERSION\D+)\d+$/${1}2/' -i server.js
git diff server.js
___ "Push change to development"
git commit -m 'Version bump' server.js; git push origin-gitlab development
