# import logins
#. /srv/login.sh
#oc-sync-login
#. /srv/login.sh
oc config use-context acm

# names
for cluster in $(oc config get-contexts -o name | sort | perl -pe 's/acm/local-cluster/'); do
  oc label ManagedCluster -l name=$cluster usage=gitlab       --overwrite=true
  oc label ManagedCluster -l name=$cluster multi-cloud=member --overwrite=true
done

# install haproxy
oc config use-context acm
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
oc -n multi-cloud-lb create configmap haproxy

# add clusters with multi-cloud=member to haproxy config
../update-haproxy.sh

# create haproxy and check it
oc -n multi-cloud-lb create -f haproxy-clusterip-service.yaml
oc -n multi-cloud-lb create -f haproxy-deployment.yaml
oc -n multi-cloud-lb get pods
HELLO_LB_ROUTE=$(oc -n multi-cloud-lb get route multi-cloud-lb -o jsonpath='{.status.ingress[*].host}')
curl -k https://${HAPROXY_LB_ROUTE}
curl -k https://${HAPROXY_DEV_LB_ROUTE}
cd -

oc get cm -n multi-cloud-lb haproxy -o=jsonpath='{.data.haproxy}'
