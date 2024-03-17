#!/bin/bash
oc config use-context acm

watch bash -c "echo '* Global Load Balancer'; echo ' - Production https://multi-cloud.box--eng.com'; ./curl_filtered https://multi-cloud.box--eng.com; echo ' '; echo ' - Development https://multi-cloud.dev.box--eng.com'; ./curl_filtered https://multi-cloud.dev.box--eng.com; echo ' '; echo ' '; echo '* Individual Clusters'; ./curl_filtered $(for cluster in $(oc get ManagedClusters -o yaml | grep 'console-' | perl -pe 's/[^v]+value[^.]+//'); do echo -n "http://hello-dev-multi-cloud$cluster http://hello-prod-multi-cloud$cluster "; done) "
