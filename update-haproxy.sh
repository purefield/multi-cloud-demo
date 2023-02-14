# import logins
. /srv/login.sh
oc-sync-login
. /srv/login.sh
oc-login acm

# update haproxy
# Define the variable of `HELLO_INGRESS`
HELLO_INGRESS_BASE=box--eng.com
HELLO_INGRESS_SUBDOMAIN=multi-cloud
# Copy the sample configmap
cd haproxy
rm -f haproxy; cp haproxy.tmpl haproxy
sed -i "s/INGRESS_BASE/${HELLO_INGRESS_BASE}/g" haproxy
sed -i "s/INGRESS_SUBDOMAIN/${HELLO_INGRESS_SUBDOMAIN}/g" haproxy
# get all managed cluster base domains
for domain in $(oc get managedcluster -o jsonpath='{range .items[*].spec.managedClusterClientConfigs[]}{.url}{"\n"}{end}' | perl -pe 's|https://api.([^:]+):\d+|$1|g' | sort -n); do
	name=$(echo $domain | cut -d\. -f1);
	echo "$name -> $domain";
	# oc label ManagedCluster -l name=$name --overwrite=true
	perl -pe "s/(\s+)(mode http)/\$1\$2\n\$1    server ${name} hello-multi-cloud.apps.${domain}:80 check inter 1s fall 1 rise 1/g" -i haproxy
done
oc set data cm -n multi-cloud-lb haproxy --from-file=haproxy
oc get cm -n multi-cloud-lb haproxy -o=jsonpath='{.data.haproxy}'
cd -
