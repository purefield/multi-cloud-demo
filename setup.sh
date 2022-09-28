# import logins
. /srv/login.sh
oc-login acm

# names
cluster1="local-cluster"
for i in 2 3 4 5; do
  cluster=$(echo ${clusters[$i]} | cut -d\. -f1)
  oc label ManagedCluster -l name=$cluster usage=gitlab --overwrite=true
done
#for i in 2 3 4 5; do
#  oc-login $i
#  oc create namespace gitlab-auth
#  oc project gitlab-auth
#  oc apply -f secrets.yaml
#  oc secrets link default gitlab-access-token --for=pull
#done

# names
cluster0="local-cluster"
cluster1=$(echo ${clusters[2]} | cut -d\. -f1)
cluster2=$(echo ${clusters[3]} | cut -d\. -f1)
cluster3=$(echo ${clusters[4]} | cut -d\. -f1)
cluster4=$(echo ${clusters[5]} | cut -d\. -f1)

# in ACM label each cluster with their clustername:cluster1,...
#                                      clusterid=cluster1,... 
oc label ManagedCluster -l name=$cluster1 clusterid=cluster1    --overwrite=true
oc label ManagedCluster -l name=$cluster1 clustername=cluster1  --overwrite=true
oc label ManagedCluster -l name=$cluster2 clusterid=cluster2    --overwrite=true
oc label ManagedCluster -l name=$cluster2 clustername=cluster2  --overwrite=true
oc label ManagedCluster -l name=$cluster3 clusterid=cluster3    --overwrite=true
oc label ManagedCluster -l name=$cluster3 clustername=cluster3  --overwrite=true
oc label ManagedCluster -l name=$cluster4 clusterid=cluster4    --overwrite=true
oc label ManagedCluster -l name=$cluster4 clustername=cluster4  --overwrite=true

# install haproxy
oc-login acm
cd haproxy
oc delete --ignore-not-found=1 -f namespace.yaml
oc wait for=delete ns/multi-cloud-lb -A
oc apply -f namespace.yaml
# Define the variable of `HELLO_INGRESS`
HELLO_INGRESS_BASE=box--eng.com
HELLO_INGRESS_SUBDOMAIN=multi-cloud
HAPROXY_LB_ROUTE=$HELLO_INGRESS_SUBDOMAIN.$HELLO_INGRESS_BASE
oc -n multi-cloud-lb create route edge multi-cloud-lb \
   --service=multi-cloud-lb-service --port=8080 --insecure-policy=Allow \
   --hostname=${HAPROXY_LB_ROUTE}
echo $HAPROXY_LB_ROUTE
HAPROXY_DEV_LB_ROUTE=$HELLO_INGRESS_SUBDOMAIN.dev.$HELLO_INGRESS_BASE
oc -n multi-cloud-lb create route edge multi-cloud-dev-lb \
   --service=multi-cloud-lb-service --port=8080 --insecure-policy=Allow \
   --hostname=${HAPROXY_DEV_LB_ROUTE}
echo $HAPROXY_DEV_LB_ROUTE
# Define the variable of `HELLO_CLUSTER1`
oc-login ocp1
HELLO_CLUSTER1=hello-multi-cloud.$(oc get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `HELLO_CLUSTER2`
oc-login ocp2
HELLO_CLUSTER2=hello-multi-cloud.$(oc get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `HELLO_CLUSTER3`
oc-login ocp3
HELLO_CLUSTER3=hello-multi-cloud.$(oc get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `HELLO_CLUSTER4`
oc-login ocp4
HELLO_CLUSTER4=hello-multi-cloud.$(oc get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Copy the sample configmap
rm -f haproxy; cp haproxy.tmpl haproxy
# Update the HAProxy configuration
sed -i "s/INGRESS_BASE/${HELLO_INGRESS_BASE}/g" haproxy
sed -i "s/INGRESS_SUBDOMAIN/${HELLO_INGRESS_SUBDOMAIN}/g" haproxy
# Replace the value with the variable `HELLO_CLUSTER1`
sed -i "s/<server1_name> <server1_hello_route>:<route_port>/cluster1 ${HELLO_CLUSTER1}:80/g" haproxy
# Replace the value with the variable `HELLO_CLUSTER2`
sed -i "s/<server2_name> <server2_hello_route>:<route_port>/cluster2 ${HELLO_CLUSTER2}:80/g" haproxy
# Replace the value with the variable `HELLO_CLUSTER3`
sed -i "s/<server3_name> <server3_hello_route>:<route_port>/cluster3 ${HELLO_CLUSTER3}:80/g" haproxy
# Replace the value with the variable `HELLO_CLUSTER4`
sed -i "s/<server4_name> <server4_hello_route>:<route_port>/cluster4 ${HELLO_CLUSTER4}:80/g" haproxy
# Create the configmap
oc-login acm
oc -n multi-cloud-lb create configmap haproxy --from-file=haproxy
# create haproxy and check it
oc -n multi-cloud-lb create -f haproxy-clusterip-service.yaml
oc -n multi-cloud-lb create -f haproxy-deployment.yaml
oc -n multi-cloud-lb get pods
HELLO_LB_ROUTE=$(oc -n multi-cloud-lb get route multi-cloud-lb -o jsonpath='{.status.ingress[*].host}')
curl -k https://${HAPROXY_LB_ROUTE}
curl -k https://${HAPROXY_DEV_LB_ROUTE}
cd -

# create application
#oc delete -f multi-cloud.yaml
#oc apply -f multi-cloud.yaml
