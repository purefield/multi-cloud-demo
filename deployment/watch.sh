#!/bin/bash
oc config use-context acm

home=$( cd "$(dirname "$([[ $0 != $BASH_SOURCE ]] && echo "$BASH_SOURCE" || echo "$0" )")" ; pwd -P )
echo $home
watch -t bash -c "echo '* Global Load Balancer'; echo ' - Production https://multi-cloud.box--eng.com'; $home/curl_filtered https://multi-cloud.box--eng.com; echo ' '; echo ' - Development https://multi-cloud.dev.box--eng.com'; $home/curl_filtered https://multi-cloud.dev.box--eng.com; echo ' '; echo ' '; echo '* Individual Clusters'; $home/curl_filtered $(for cluster in $(oc get ManagedClusters -o yaml | grep 'console-' | perl -pe 's/[^v]+value[^.]+//'); do echo -n "http://hello-dev-multi-cloud$cluster http://hello-prod-multi-cloud$cluster "; done) "
