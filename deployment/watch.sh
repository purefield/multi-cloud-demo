oc config use-context acm
watch "function curl { $(which curl) --max-time 0.5 -ks \$@ | grep -i hello; };"\
"echo '* Global Load Balancer'; 

echo ' - Production https://multi-cloud.box--eng.com'; 
curl https://multi-cloud.box--eng.com; echo ' '; 

echo ' - Development https://multi-cloud.dev.box--eng.com'; 
curl https://multi-cloud.dev.box--eng.com; 

echo ' '; echo ' '; echo '* Individual Clusters'; 
curl $(for cluster in $(oc get ManagedClusters -o yaml | grep 'console-' | perl -pe 's/[^v]+value[^.]+//'); do echo -n "http://hello-dev-multi-cloud$cluster http://hello-prod-multi-cloud$cluster "; done)
"
